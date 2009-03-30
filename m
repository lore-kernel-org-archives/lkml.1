Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZC3VKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZC3VKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZC3VK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:10:26 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:38538 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757443AbZC3VKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:10:24 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net D6A9C39A626
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Zero length files - an alternative approach?
To: Chris Mason <chris.mason@oracle.com>,
       =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 30 Mar 2009 23:10:20 +0200
References: <cl0KI-3zZ-3@gated-at.bofh.it> <cl1oA-4El-9@gated-at.bofh.it> <clp6o-91-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1LoOkP-0001bk-D6@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:
> On Sun, 2009-03-29 at 12:22 +0100, Måns Rullgård wrote:

>> Consider this scenario:
>> 
>> 1. Create/write/close newfile
>> 2. Rename newfile to oldfile
> 
> 2a. create oldfile again
> 2b. fsync oldfile
> 
>> 3. Open/read oldfile.  This must return the new contents.
>> 4. System crash and reboot before delayed allocation/flush complete
>> 5. Open/read oldfile.  Old contents now returned.
>> 
> 
> What happens to the new generation of oldfile?  We could insert
> dependency tracking so that we know the fsync of oldfile is supposed to
> also fsync the rename'd new file.

If rename() is BEFORE create(oldfile) and if create(oldfile) is committed,
oldfile will be the newly created file. If the sync() is interrupted by the
crash, any intermediate state may appear. If the system crashes before
create(), either the old oldfile or newfile should be visible.

