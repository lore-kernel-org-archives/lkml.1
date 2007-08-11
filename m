Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbXHKCaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbXHKCaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 22:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbXHKCaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 22:30:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:53356 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbXHKCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 22:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q1AFar0Pda6rKxsJu8j7fpOonpMHIW7eoU3WdhsCSf8GC2fA1WseZcFuLZxH/L8SgknKXCcdgZZI903g2EHzEL0VKP3GlDup3+TF18TXV7mfmfN9HsNBasjFpCliG2jbjO+ZCLH273nJRsVYFyiXZ6xBC6qmwLx+z8FzD3lmcFs=
Message-ID: <4dfa50520708101930h156354c8t492677dd45e2be62@mail.gmail.com>
Date: Fri, 10 Aug 2007 20:30:19 -0600
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
In-Reply-To: <46BCE929.5070902@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B5B290.4040907@s5r6.in-berlin.de>
	 <20070805162141.GI6221@jupiter.solarsys.private>
	 <46B6053E.2050708@s5r6.in-berlin.de>
	 <20070810230831.59cbc50f@hyperion.delvare>
	 <46BCE6D0.7060300@s5r6.in-berlin.de>
	 <46BCE929.5070902@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan, (Replying to everyone on the list, sorry!)

On 8/10/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Should I hardwire correct dividers or pulse per rev in sensors.conf or
> is the driver supposed to work the correct dividers out --- like it did
> before 2.6.23-rc?

The dividers are read-only in userspace. The driver manages the
dividers automatically. The dividers are needed because the w83627ehf
chip only has an 8 bit register to count pulses for each fan. So if
the fan is moving slowly, you want the divider to be 128 so that every
pulse gets counted. If the fan is moving fast, you want the divider to
be 1 so that the register doesn't overflow. Once the register is read
in by the driver, the effect of the divider is cancelled out in
software so that you get an RPM reading from the fan. One side effect
of this is that a fast moving fan reports the RPM more quickly than a
slow moving fan.

If you turn on HWMON debugging, the driver will report when it is
changing the divider in dmesg.

Hope that helps,
David
