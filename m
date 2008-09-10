Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYIJNAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYIJNAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYIJNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:00:41 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61135 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIJNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XCdiArRMUPAtugO5ahXXPlGse6bjSzdLFsfM85GF4+HoPbTX53a04Y0N/kt8i8r5lo
         f51uoH3i8mIFnvezatrtyZHXluNq3coveRwXTfyxcJ4M2qL3bV2MQqnFmSYRYSee24kR
         Sd/muHvsJmAlbGgPXcPPIUS+KOteBkcqhTmiI=
Date: Wed, 10 Sep 2008 09:00:36 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080910130035.GB25221@anvil.corenet.prv>
References: <20080813152459.4d6bb0cb@ephemeral> <20080815031435.GD9438@anvil.corenet.prv> <20080829024959.68bcdc98@fred>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829024959.68bcdc98@fred>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 02:49:59AM -0400, Andres Salomon wrote:
> > > +static void hgpk_spewing_hack(struct psmouse *psmouse, int l, int
> > > r, int x,
> > > +		int y)
> > > +{
> > > +	struct hgpk_data *priv = psmouse->private;
> > > +	static int count;
> > > +	static int x_tally;
> > > +	static int y_tally;
> > 
> > Hmm, I guess we'll never see 2 such devices in one box, but still
> > moving it to psmouse->private woudl be a good practice.
> 
> 
> Can you please clarify this comment?
> 

If you ever have 2 such devices in the same box use of static variables
will cause the code to not work properly because they will be shared
between the devices. Proper way is to move them into per-device
structure.

-- 
Dmitry
