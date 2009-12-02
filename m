Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbZLBIyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbZLBIyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZLBIyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:54:03 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:41346 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754853AbZLBIyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:54:02 -0500
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091202091951.5ec6bb83@hyperion.delvare>
References: <20091202091951.5ec6bb83@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Dec 2009 09:54:02 +0100
Message-ID: <1259744042.8188.397.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
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

The driver seems to load and work fine here (on a PowerBook5,8) with the
patch, so feel free to add a Tested-By: line for me.


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



-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
