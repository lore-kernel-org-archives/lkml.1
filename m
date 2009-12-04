Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZLDCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZLDCmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZLDCmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:42:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:36071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZLDCmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:42:37 -0500
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091202091951.5ec6bb83@hyperion.delvare>
References: <20091202091951.5ec6bb83@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:40:54 +1100
Message-ID: <1259894454.2076.1246.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 09:19 +0100, Jean Delvare wrote:
> Michel, Darrick,
> 
> Apparently you are using the therm_adt746x driver, so maybe you would
> be interested in testing and carrying the following patch. I've sent it
> to Colin Leroy, who is listed as the maintainer for this driver, 1.5
> month ago, but did not hear back.

I will take it.

Basic rule is: CC to linuxppc-dev@lists.ozlabs.org ;-)

That way it gets picked up by patchwork and doesn't get lost. Even if it
goes low on my priority list it will not be lost and I'll eventually
pick it up.

Cheers,
Ben.

> * * * * *
> 
> The ADT746x don't have any register at sub-address 0, so better use an
> existing register for the initial test read.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Tested-by: Tim Shepard <shep@alum.mit.edu>
> Cc: Colin Leroy <colin@colino.net>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  drivers/macintosh/therm_adt746x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.32-rc4.orig/drivers/macintosh/therm_adt746x.c	2009-10-12 11:53:59.000000000 +0200
> +++ linux-2.6.32-rc4/drivers/macintosh/therm_adt746x.c	2009-10-14 17:27:46.000000000 +0200
> @@ -387,7 +387,7 @@ static int probe_thermostat(struct i2c_c
>  	i2c_set_clientdata(client, th);
>  	th->clt = client;
>  
> -	rc = read_reg(th, 0);
> +	rc = read_reg(th, CONFIG_REG);
>  	if (rc < 0) {
>  		dev_err(&client->dev, "Thermostat failed to read config!\n");
>  		kfree(th);
> 
> 


