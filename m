Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZLTKox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZLTKox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZLTKow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:44:52 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:51020 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZLTKov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:44:51 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH]Silancing a false positive: "may be used uninitialized"
Date: Sun, 20 Dec 2009 12:43:19 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc1; KDE/4.2.4; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200912200903.28002.mitov@issp.bas.bg> <20091220095644.GA17838@verge.net.au>
In-Reply-To: <20091220095644.GA17838@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912201243.20111.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009 11:56:44 am Simon Horman wrote:
> On Sun, Dec 20, 2009 at 09:03:27AM +0200, Marin Mitov wrote:
> > Hello all,
> > 
> > Silancing a false positive:
> > warning: 'width' may be used uninitialized in this function
> > drivers/gpu/drm/drm_edid.c
> 
> Is it guaranteed that the switch will always see a value covered by the
> four cases it has? 

Yes it is. The value is masked (& 0xc0) so all the possible values are
(0x00, 0x40, 0x80, 0xc0) covered by the switch. That's why it is false positive.

> If not width would be used without having been initialised.
> 
> Perhaps adding
> 
> 		default:
> 			BUG();
> 
> would be worthwhile?
> 
> > 
> > Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> > ==========================================================================
> > --- a/drivers/gpu/drm/drm_edid.c	2009-12-20 07:43:57.000000000 +0200
> > +++ b/drivers/gpu/drm/drm_edid.c	2009-12-20 07:45:49.000000000 +0200
> > @@ -913,7 +913,7 @@
> >  	const int rates[] = { 60, 85, 75, 60, 50 };
> >  
> >  	for (i = 0; i < 4; i++) {
> > -		int width, height;
> > +		int uninitialized_var(width), height;
> >  		cvt = &(timing->data.other_data.data.cvt[i]);
> >  
> >  		height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 8) + 1) * 2;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
