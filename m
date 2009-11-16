Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZKPOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZKPOzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZKPOze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:55:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37798 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZKPOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:55:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fpn+Jt5uW/1ds66GCDG/kOqSkarsHITpthv5fLg+CBBm3Ja/qLH68E0xQdYEV6s4E4
         NH9ouev7qsWDEZMBFPbmfJpGs+cocHL8xseQp4MbffODpuZwTg85fAHyb4taBygcnMXi
         q8Xajpf+lyVKGxO9fHy1GGSYqDFNymmks0Juk=
Date: Mon, 16 Nov 2009 17:56:18 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       zaurus-devel@www.linuxtogo.org
Subject: Re: [RFC PATCH 1/2] power: implement platform battery driver
Message-ID: <20091116145618.GF22476@home.pavel.comp>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com> <1257820673-30801-2-git-send-email-fercerpav@gmail.com> <20091116010814.GB4927@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116010814.GB4927@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Mon, Nov 16, 2009 at 04:08:14AM +0300, Anton Vorontsov wrote:
> On Tue, Nov 10, 2009 at 05:37:52AM +0300, Paul Fertser wrote:
> [...]
> > +static int platform_bat_get_property(struct power_supply *psy,
> > +				       enum power_supply_property psp,
> > +				       union power_supply_propval *val)
> > +{
> > +	struct platform_battery *bat =
> > +				container_of(psy, struct platform_battery, psy);
> > +	size_t i;
> > +	int present = 1;
> > +
> > +	if (bat->pdata->is_present)
> > +		present = bat->pdata->is_present();
> > +
> > +	if (psp != POWER_SUPPLY_PROP_PRESENT && !present)
> > +		return -ENODEV;
> > +
> > +	for (i = 0; i < psy->num_properties; i++)
> > +		if (psy->properties[i] == psp) {
> > +			val->intval = bat->pdata->get_property[i]();
> > +			return 0;
> > +		}
> 
> I'm not sure I like this. Why don't you just pass the enum
> to pdata hook? So platform devices would just use a single
> get_property function and a 'switch', like the rest of the
> power supply drivers.

Of course, i thought about that. It seemed to me that it would tie platform
code and power_supply API a bit too much, so if you ever change the API,
the platform code would need to be changed as well. But if you think that
it is a non-issue, sure, i'll do it the way you suggest.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
