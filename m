Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbZCYPS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbZCYPS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZCYPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:18:48 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43811 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZCYPSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vrtYfhcTqbRW/TTeq7vnbvCn5exikDgalSMiQ0Z0onM6hVc98M/Cktpc3Qh+GvC5Lp
         yblHrdTXiYGjtIdiJhhPXVIsTI5WfRz8/JxgTgKdlyVupo9UJ+A/sHlS+DBr2NcLznEa
         d5WKlld72YGe55jCfimq8NawrQg+xm3l32/3M=
MIME-Version: 1.0
In-Reply-To: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
	 <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com>
	 <20090310154745.GF23075@mit.edu>
	 <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com>
	 <20090325151122.GA14881@atrey.karlin.mff.cuni.cz>
	 <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
Date: Wed, 25 Mar 2009 18:18:43 +0300
Message-ID: <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
Subject: Re: next-20090310: ext4 hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/25 Jan Kara <jack@suse.cz>:
>> > So, I think I need to try it on 2.6.29-rc7 again.
>>   I've looked into this. Obviously, what's happenning is that we delete
>> an inode and jbd2_journal_release_jbd_inode() finds inode is just under
>> writeout in transaction commit and thus it waits. But it gets never woken
>> up and because it has a handle from the transaction, every one eventually
>> blocks on waiting for a transaction to finish.
>>   But I don't really see how that can happen. The code is really
>> straightforward and everything happens under j_list_lock... Strange.
>  BTW: Is the system SMP?
No, it is UP system.

The bug exists even in 2.6.29, I posted it with a new topic.
