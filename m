Return-Path: <linux-kernel-owner+w=401wt.eu-S2992654AbXCGWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654AbXCGWj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992657AbXCGWj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:39:26 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:56203 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992654AbXCGWjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:39:25 -0500
Subject: Re: Radeon xpress 200m and radeonfb kinda work
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Johan Henriksson <jhn98032@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45ECB2D0.3080205@telia.com>
References: <45ECB2D0.3080205@telia.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 09:39:27 +1100
Message-Id: <1173307167.3219.111.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-03-06 at 01:16 +0100, Johan Henriksson wrote:
> Hi!
> 
> I have gotten the radeon xpress 200m (the version without dedicated
> vmem)
>  to work with radeonfb.
> The attached patch (against linux-2.6.20.1) works for me.
> Since I don't have any docs for the card I am unsure if the patch is 
> 100% correct.
> Can someone else with a 200m try it out?
> (I have tested it by enabling  fbcon and radeonfb in the kernel  and
>  added "video=radeonfb" to lilo. This gave me a nice 1280x800
> console :) )
> 
> /Johan Henriksson
> 
> Please CC, I'm not on the list.
> 
> @@ -2329,7 +2332,7 @@ static int __devinit radeonfb_pci_regist
>  		/* -2 is special: means  ON on mobility chips and do not
>  		 * change on others
>  		 */
> -		radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1, ignore_devlist, force_sleep);
> +		radeonfb_pm_init(rinfo, -1,ignore_devlist, force_sleep);//rinfo->is_mobility ? 1 : -1);

That looks like it might break !200M. Maybe something line
rinfo->is_mobility && !rinfo->rs480 (with additional modifications to
define an rs480, of course) - or a more generic name indicating why the
rs480 is different?

Regards,

Nigel

