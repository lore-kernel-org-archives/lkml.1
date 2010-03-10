Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0CJG4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:56:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57012 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab0CJG4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tbVS6o7FLlMSNymhfzcqwx3dQeFap7T7tjK9yYrxWGjoHVFaRRLv0DvMHm060/doUQ
         PfRKfq55XIBykSUWzsUluuBmWdVmEfWA9BUH+xC4+eVyA3MCMvX/xMqU12n1sOTKWkQ6
         dtLpX+IekWu4mU9fFJrHPcYWbISsXJMsTH4jk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening input device
Date: Tue, 9 Mar 2010 22:56:38 -0800
User-Agent: KMail/1.13.0 (Linux/2.6.34-rc1; KDE/4.4.0; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>,
       jkosina@suse.cz
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com> <20100310062015.GA2445@core.coreip.homeip.net> <201003100749.20723.oliver@neukum.org>
In-Reply-To: <201003100749.20723.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003092256.39223.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010 10:49:20 pm Oliver Neukum wrote:
> Am Mittwoch, 10. März 2010 07:20:15 schrieb Dmitry Torokhov:
> > > I was willing to let the open call go unprotected. But ended up
> > > checking that the three callees were fine (they do not call any of the
> > > other functions that take the mutex).
> > > 
> > > Since the fops_put/fops_get do protect that section from the handler
> > > removal and I can't think of any other race right now, I think your
> > > version is really better.
> > > 
> > > Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > 
> > OK, applied 2 Thadeu's patches and one Arnd's.
> 
> Jiri,
> 
> it is possible that this requires a change in usbhid as it uses BKL.
> Do you remember?
>

No, different layer altogether.

-- 
Dmitry
