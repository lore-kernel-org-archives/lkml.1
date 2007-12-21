Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXLUQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXLUQTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXLUQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:18:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:2956 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbXLUQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X4A2GHBjYlmBv8CTYtlIYfWMqcSddwNYnkii0QG5LSfwYTOmAUmKxiOgYY4Gia9oFuNekhCbbPCCOm+n7voG28UIQslWNlYYFTkcuTKNwT12osHgEoWFs6QZP2Qo2gOp1M1RBYlDRIXkTm0oYXuwTb89tt07Zu+sbEN0EF0JDSk=
Message-ID: <2c0942db0712210818q1a16291au3b3ddf395867542a@mail.gmail.com>
Date: Fri, 21 Dec 2007 08:18:50 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Christian Hammers" <ch@lathspell.de>
Subject: Re: Debugging process hanging in D status and not responding to SIGKILL
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071221163845.6fa3f2a9@sys-251.netcologne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071221163845.6fa3f2a9@sys-251.netcologne.de>
X-Google-Sender-Auth: 62129dcdf4d28e07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21, 2007 7:38 AM, Christian Hammers <ch@lathspell.de> wrote:
> Hello
>
> Occasionally all my apache2 processes hang in "D" process status where they are
> no longer responsible to SIGKILL which makes the server almost un-rebootable.
> The processes usually vanish after about 15-30min.
>
> I know that this usually means "I/O wait" somewhere deep inside a kernel
> function where signals are not handled.
>
> But using "strace -p <pid>" I can only see that the last called function is
> flock() (according to /proc/<pid>/fd somebody produced a deadlock when using
> PHP sessions). But flock() normally terminates on SIGTERM and SIGKILL.
>
> Could it be a problem with my SCSI driver who's involed in the flock process?
> The problem usually occurs on two other webserver at the same time, one using
> the same hardware and one being a Dell 6850 with Dell PERC RAID, though.
>
> How can I get further debugging information that could give me a hint?

Do an

   echo t >/proc/sysrq-trigger

and see what it shows.
