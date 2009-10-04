Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZJDPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZJDPKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 11:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZJDPKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 11:10:42 -0400
Received: from mail-iw0-f195.google.com ([209.85.223.195]:52408 "EHLO
	mail-iw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZJDPKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 11:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MHutPmXZ6DbdvrpSDEea5F+suxf2SXidqU8Dc6gXC4a68H6GgBvzcXmE85nB/3KCof
         PTHS1JkFE01R8jIiLv/XkDuhPh8oV5yu40FSqoSgBFga8L5ngygKeGesQNHQn+rdJ+pk
         Fi2pb68A5W6qgLPfbJAzWjC2B1bgvxaBolgbk=
MIME-Version: 1.0
In-Reply-To: <loom.20091003T131407-865@post.gmane.org>
References: <1254518602.5050.4.camel@hurina>
	 <loom.20091003T131407-865@post.gmane.org>
Date: Mon, 5 Oct 2009 00:10:04 +0900
Message-ID: <2f11576a0910040810g1cb5bb26l1c522a4f51f843bb@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Timo Sirainen <tss@iki.fi>, Bryan Donlan <bdonlan@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> PR_SET_PROCTITLE_AREA updates mm_struct->arg_start and arg_end to the
>> given pointers, which makes it possible for user space to implement
>> setproctitle(3) cleanly.
>>
>>
> Why can't you use PR_SET_NAME ?

example:

% ps -ef |grep sendmail
root      2444     1  0 Oct04 ?        00:00:00 sendmail: accepting connections
smmsp     2454     1  0 Oct04 ?        00:00:00 sendmail: Queue
runner@01:00:00 for /var/spool/clientmqueue
kosaki    3927  2907  0 00:02 pts/1    00:00:00 grep sendmail



Almost setproctitle() heavy user (e.g. sendmail, openssh and some bsd
style daemon programs) use long string rather than 16.



> And with PR_SET_NAME, you can a name per thread, which you can't do by changing
> arg[0] name (it should be shared across all thread).
>
> Matthieu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
