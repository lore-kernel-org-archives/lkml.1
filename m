Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZC2KoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZC2KoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 06:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZC2KoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 06:44:04 -0400
Received: from newton.gmurray.org.uk ([81.2.114.237]:41092 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZC2KoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 06:44:03 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 newton.gmurray.org.uk n2TAhxnP010031
X-Hashcash: 1:22:090329:linux-kernel@vger.kernel.org::QEFN6M0b+ijO+rdH:000000000000000000000000000000000ExCc
From: Graham Murray <graham@gmurray.org.uk>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Zero length files - an alternative approach?
X-Hashcash: 1:22:090329:linux-ext4@vger.kernel.org::OtBqxEezQK8bFkhZ:000000000000000000000000000000000005Ov9
Date: Sun, 29 Mar 2009 11:43:59 +0100
Message-ID: <87bprka9sg.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a thought on the ongoing discussion of dataloss with ext4 vs ext3.

Taking the common scenario:
Read oldfile
create newfile file
write newfile data
close newfile
rename newfile to oldfile

When using this scenario, the application writer wants to ensure that
either the old or new content are present. With delayed allocation, this
can lead to zero length files. Most of the suggestions on how to address
this have involved syncing the data either before the rename or making
the rename sync the data.

What about, instead of 'bringing forward' the allocation and flushing of
the data, would it be possible to instead delay the rename until after
the blocks for newfile have been allocated and the data buffers flushed?
This would keep the performance benefits of delayed allocation etc and
also satisfy the applications developers' apparent dislike of using
fsync(). It would give better performance that syncing the data at
rename time (either using fsync() or automatically) and satisfy the
requirements that either the old or new content is present.

I am not a filesystem developer, so do not know how feasible this would
be. 
