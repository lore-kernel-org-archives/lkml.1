Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYGYRCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYGYRCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYGYRCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:02:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:47437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYGYRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ldFWTixYRSA80m2q/oT/L6Zc0t01JH2RwYJG12VE6x2xYAJfJmJUO4fUMkkPEZ5PIu
         aEsvR7HfG9/WooZiG40kA/MmP/hr8qtkO6jJPGPvNAJ0/KRvr9g/x34LaMR7ZGNOLrQH
         Ir0zdaWUubavNrzrxluXwzrbAx0tvYq13c1CU=
Message-ID: <9e4733910807251002w7da115e5r53600f1cf4e3891@mail.gmail.com>
Date: Fri, 25 Jul 2008 13:02:41 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/4] of: adapt of_find_i2c_driver() to be usable by SPI also
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <fa686aa40807250921v73bec21cya6b4cd494f12f2e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073311.8485.16226.stgit@trillian.secretlab.ca>
	 <9e4733910807250840n48c6ae79l27af4f320b5b1df1@mail.gmail.com>
	 <fa686aa40807250921v73bec21cya6b4cd494f12f2e8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Jul 25, 2008 at 11:40 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
>  > On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>  >> From: Grant Likely <grant.likely@secretlab.ca>
>  >>
>
> >>  + * At the moment, a single table is used for all bus types because it is
>  >>  + * assumed that the data size is small and that the compatible values
>  >>  + * should already be distinct enough to differentiate between SPI, I2C
>  >>  + * and other devices.
>  >
>  > Maybe add a section recommending to update the alias list in the linux
>  > device driver before adding entries here? This table should be a last
>  > resort. I'm not even sure this table should exist, what would be a
>  > case where we would need to make an entry here instead of fixing the
>  > device driver by adding an alias name?
>
>
> In principle I agree.  However, this patch is simply porting the i2c
>  specific code to something that can be used by both SPI and I2C.  I
>  don't want to rework the actual mechanism in this particular patch.  I
>  can submit an additional patch to change this along with reworking
>  some of the behavior that needs to be improved.
>
>
>  >>  + * First method is to lookup the compatible value in of_modalias_table.
>  >>  + * Second is to look for a "linux,<modalias>" entry in the compatible list
>  >>  + * and used that for modalias.  Third is to strip off the manufacturer
>  >>  + * prefix from the first compatible entry and use the remainder as modalias
>  >
>  > I also think this is a problem. Embedding the name of Linux device
>  > drivers into device firmware makes it almost impossible to rename the
>  > device driver.  Again, what is a case where generic part numbers can't
>  > be listed in the alias section of the linux device driver?
>  >
>  > Even eeprom was just fixed to take generic part numbers (at24).
>
>
> Again, I agree, but this change is very much a stop gap measure to get
>  things working in a sane way without having to create bad device tree
>  bindings (device tree bindings are hard to change, code is not).  I've
>  been considering posting a patch to remove this clause from the
>  functions, but that needs to be reviewed separately from this change.

Isn't putting "compatible="linux,modalias"" into your device tree a
really bad idea?

>
>  Thanks,
>
> g.
>
>  --
>  Grant Likely, B.Sc., P.Eng.
>  Secret Lab Technologies Ltd.
>


-- 
Jon Smirl
jonsmirl@gmail.com
