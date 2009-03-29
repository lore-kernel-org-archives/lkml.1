Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZC2LXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZC2LXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZC2LWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:22:53 -0400
Received: from main.gmane.org ([80.91.229.2]:32876 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZC2LWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:22:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 12:22:29 +0100
Message-ID: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
Cancel-Lock: sha1:OuLM60Mjxt9fFByHwVsHDe+cNZA=
Cc: linux-ext4@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graham Murray <graham@gmurray.org.uk> writes:

> Just a thought on the ongoing discussion of dataloss with ext4 vs ext3.
>
> Taking the common scenario:
> Read oldfile
> create newfile file
> write newfile data
> close newfile
> rename newfile to oldfile
>
> When using this scenario, the application writer wants to ensure that
> either the old or new content are present. With delayed allocation, this
> can lead to zero length files. Most of the suggestions on how to address
> this have involved syncing the data either before the rename or making
> the rename sync the data.
>
> What about, instead of 'bringing forward' the allocation and flushing of
> the data, would it be possible to instead delay the rename until after
> the blocks for newfile have been allocated and the data buffers flushed?
> This would keep the performance benefits of delayed allocation etc and
> also satisfy the applications developers' apparent dislike of using
> fsync(). It would give better performance that syncing the data at
> rename time (either using fsync() or automatically) and satisfy the
> requirements that either the old or new content is present.

Consider this scenario:

1. Create/write/close newfile
2. Rename newfile to oldfile
3. Open/read oldfile.  This must return the new contents.
4. System crash and reboot before delayed allocation/flush complete
5. Open/read oldfile.  Old contents now returned.

This rollback isn't obviously, to me at least, without problems of its
own.

-- 
Måns Rullgård
mans@mansr.com

