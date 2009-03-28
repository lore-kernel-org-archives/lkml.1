Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbZC1BW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbZC1BW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 21:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZC1BWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 21:22:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:58411 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZC1BWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 21:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C0n6yvCKFPg3QmeDjsBHlGmTnklLDqpFyp4C3P4aVMsvPITBVzuF8AO/J3RWUJ99Lg
         VAIhPmxPvK3ZdAAvT/sihUwiDiVDKZ+6+a2+HZJGQHaqq8wfvDbTlr7UQQ20BIcti3LU
         k3ZuQnP0wkKkMX1ODk4hJPJ/DdGL/oBQEVQfE=
MIME-Version: 1.0
In-Reply-To: <49CCCB0A.6070701@nokia.com>
References: <49CCCB0A.6070701@nokia.com>
Date: Sat, 28 Mar 2009 10:22:46 +0900
X-Google-Sender-Auth: fa7f1872339d5dbe
Message-ID: <9c9fda240903271822w29aa131ch57c33f95e543c883@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: Kyungmin Park <kmpark@infradead.org>
To: Artem.Bityutskiy@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I also got these request. the file is empty at rename operatoin in
case of sudden power off.
they say it's different from jffs2. in case of jffs2, it points old
files even though power off.
then why is UBIFS different. fix it as before. I said it's not
filesystem bug. it's expected behaviors.

In my case, I persuade the application people to change their
application to use fsync. also if fsync doesn't solve this problem,
add mirror scheme, duplicate file to avoid empty file problem.

Frankly I'm not sure which one is better. how much filesystem support
it. but remember that application programmer also don't want to change
their application when filesystem is changed.
"The application is not changed, only filesystem is changed. so it's
filesystem problem, not us"

Thank you,
Kyungmin Park

On Fri, Mar 27, 2009 at 9:48 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
> UBIFS has exactly the same properties like ext4 - in case
> of power cuts:
>
> 1. truncate/write/close leads to empty files
> 2. create/write/rename leads to empty files
>
> UBIFS is used in hand-held and and power-cuts are very
> often there, because users just remove battery often.
>
> I realize the "reality is different" argument, and already
> concluded that we need a similar changes as Theo has done
> for ext4:
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=bf1b69c0db7f9b9d8f02e94d40b19fca8336b991
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=f32b730a69bd56c5c9d704d8b75f03e90e290971
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=8411e347c3306ed36b8ca88611bf5fbf4d27d705
>
> We have a problem that user-space people do not want to
> use 'fsync()', even when they are pointed to their code
> which is doing create/write/rename/close without fsync().
>
> They just say - this is file-system bug, it is fixed in
> ext4 now, just fix the bug in UBIFS.
>
> I tell them, that is not a fix, that is band-aid, because
> ext4 issues asynchronous write, and a power cut can lead
> to corruptions anyway.
>
> I tell them, we can make this in UBIFS, but please, anyway
> add fsync() to your application. They say - now, we will
> will not - you fix your UBIFS.
>
> And because there is so much flood and about this, it is
> so difficult to have reasonable arguments. I want to say
> people - please, still use fsync(), if this is about the
> performance/reliability trade-off - make it optional.
> But they instead say - respected people are on our side,
> go away. And point me this:
> http://www.advogato.org/person/mjg59/diary/195.html
> http://thread.gmane.org/gmane.linux.kernel/811167/focus=811700
> http://article.gmane.org/gmane.comp.lang.perl.perl5.porters/67352
>
> And they say that BTRFS and XFS are going to fix userspace
> as well, and point me at this:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/317781/comments/175
>
> This all became so messy and controversial. What should I do
> to persuade userspace to use 'fsync()' even if we hack UBIFS
> similarly to ext4? Suggestions?
>
> --
> Best Regards,
> Artem Bityutskiy (áÒÔ£Í âÉÔÀÃËÉÊ)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
>
