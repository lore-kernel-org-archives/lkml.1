Return-Path: <linux-kernel-owner+w=401wt.eu-S1765071AbYBTTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765071AbYBTTA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYBTTAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:00:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:37878 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYBTTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gCjj6gUPNHkfZJGCgPVwfAFSMi7DbtN9N4WlK5FYznO2HJhy+gsiJlDn79zCYlABXiQUX3jkp1AbDqcTVhgUi5yKOimHcgfnLSeQ55wgyG53iuiO9uFKNgmdKBUdQdcgnYRZO31bx+JuOWnDRBm1vklYcyJv5wZBFbAE+mSb88M=
Message-ID: <47BC78DC.7060507@gmail.com>
Date: Wed, 20 Feb 2008 20:00:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tty && pid problems
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org> <20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru> <m1skzq9a59.fsf@ebiederm.dsl.xmission.com> <23492.1203464394@turing-police.cc.vt.edu> <20080220161823.GB146@tv-sign.ru> <20080220162858.GC146@tv-sign.ru>
In-Reply-To: <20080220162858.GC146@tv-sign.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2008 05:28 PM, Oleg Nesterov wrote:
> I think you can revert the tty-bkl-pushdown.patch. Or, as Eric suggested, just
> revert this
> 
> 	@@ -1222,7 +1221,7 @@ static const struct file_operations tty_
> 		.read           = tty_read,
> 		.write          = tty_write,
> 		.poll           = tty_poll,
> 	-       .ioctl          = tty_ioctl,
> 	+       .unlocked_ioctl = tty_ioctl,
> 		.compat_ioctl   = tty_compat_ioctl,
> 		.open           = tty_open,
> 		.release        = tty_release,
> 	@@ -1235,7 +1234,7 @@ static const struct file_operations ptmx
> 		.read           = tty_read,
> 		.write          = tty_write,
> 		.poll           = tty_poll,
> 	-       .ioctl          = tty_ioctl,
> 	+       .unlocked_ioctl = tty_ioctl,
> 		.compat_ioctl   = tty_compat_ioctl,
> 		.open           = ptmx_open,
> 		.release        = tty_release,
> 	@@ -1248,7 +1247,7 @@ static const struct file_operations cons
> 		.read           = tty_read,
> 		.write          = redirected_tty_write,
> 		.poll           = tty_poll,
> 	-       .ioctl          = tty_ioctl,
> 	+       .unlocked_ioctl = tty_ioctl,
> 		.compat_ioctl   = tty_compat_ioctl,
> 		.open           = tty_open,
> 		.release        = tty_release,
> 	@@ -1260,7 +1259,7 @@ static const struct file_operations hung
> 		.read           = hung_up_tty_read,
> 		.write          = hung_up_tty_write,
> 		.poll           = hung_up_tty_poll,
> 	-       .ioctl          = hung_up_tty_ioctl,
> 	+       .unlocked_ioctl = hung_up_tty_ioctl,
> 		.compat_ioctl   = hung_up_tty_compat_ioctl,
> 		.release        = tty_release,
> 	 };
> 
> chunk.

This would result in unpredictable behaviour. If I left locking apart, ioctl 
prototype != unlocked_ioctl prototype.
