Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZH3VWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZH3VWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZH3VWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 17:22:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:47610 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZH3VWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 17:22:52 -0400
Subject: Re: [PATCH] powermac: thermal control turns system off in normal
 temperature conditions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Lyonel Vincent <lyonel@ezix.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200908302054.20498.bzolnier@gmail.com>
References: <200908302054.20498.bzolnier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Aug 2009 07:22:31 +1000
Message-Id: <1251667351.20467.201.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-30 at 20:54 +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Lyonel Vincent <lyonel@ezix.org>
> Subject: [PATCH] powermac: thermal control turns system off in normal temperature conditions
> 
> On certain PowerMacs, a module (therm_windtunnel) controls various
> thermal settings (it can report CPU/case temperature, change speed
> of internal fans, etc.)
> 
> By default, the hardware thermal control has a temperature limit to
> protect the computer from damages (the default limit seems to be 80°C)
> but therm_windtunnel.c reduces it to an anormaly low value (65°C),
> which means that he computer will shut down randomly when hit by direct
> sun light or during summer (summer in France can be quite hot), actually
> possibly losing data instead of protecting it.
> 
> The overheat limit in therm_windtunnel.c:253-254 should be set to 75°C
> and 70°C instead of 65°C and 60°C respectively.

Looks reasonable, thanks.

Ben.

> From: Lyonel Vincent <lyonel@ezix.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Resurrected from Fedora's bugzilla (aka The Big Black Hole):
> https://bugzilla.redhat.com/show_bug.cgi?id=171937
> 
> The patch itself seems perfectly valid to me
> (especially given comments in therm_windtunnel.c).
> 
>  drivers/macintosh/therm_windtunnel.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/macintosh/therm_windtunnel.c
> ===================================================================
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -239,8 +239,8 @@ setup_hardware( void )
>  	 * to be on the safe side (OSX doesn't)...
>  	 */
>  	if( x.overheat_temp == (80 << 8) ) {
> -		x.overheat_temp = 65 << 8;
> -		x.overheat_hyst = 60 << 8;
> +		x.overheat_temp = 75 << 8;
> +		x.overheat_hyst = 70 << 8;
>  		write_reg( x.thermostat, 2, x.overheat_hyst, 2 );
>  		write_reg( x.thermostat, 3, x.overheat_temp, 2 );
>  

