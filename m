Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZG0IpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZG0IpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZG0IpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:45:09 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63365 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZG0IpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uI9wNYWQ0Wk6biUIUMfYDToepZ9MYlCGGZ7BhAmM1jV0Gj0d2KTxAS4IaSoW35+7N1
         q7Ac81pFTKEaCgSexw/IQ0RQkL+TxL7NOIo3IIYjcZ7URntqn9hmyqc/flMrapvCaPyk
         JJOIjkEFkVvVjLqO46s6YcCg1GfXM4y+EULcA=
MIME-Version: 1.0
In-Reply-To: <3zAHs5O6maO.A.u-B.KHObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.u-B.KHObKB@chimera>
Date: Mon, 27 Jul 2009 16:45:07 +0800
Message-ID: <a8e1da0907270145t1b7e4b7ey30793b97bcd87916@mail.gmail.com>
Subject: Re: [Bug #13837] Input : regression - touchpad not detected
From: Dave Young <hidave.darkstar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).

Now I'm not sure if it's a regression, because it happens not every
boot. Maybe I just noticed it after 2.6.30

jiri, I found the place via extra printk messages added to the i8042.c

in function i8042_check_aux(), when touchpad detecting fail, it fall
into following error path:

 if (wait_for_completion_timeout(&i8042_aux_irq_delivered,
                                        msecs_to_jiffies(250)) == 0) { [snip] }

so maybe the timeout value need to be increased? I try redo the
i8042_setup_aux after it fails, it fixes the problem indeed, which one
is the proper fix do you think? If it's the right fix I can post the
patch.

>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13837
> Subject         : Input : regression - touchpad not detected
> Submitter       : Dave Young <hidave.darkstar@gmail.com>
> Date            : 2009-07-17 07:13 (10 days old)
> References      : http://marc.info/?l=linux-kernel&m=124780763701571&w=4
>
>
>



-- 
Regards
dave
