Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZJ2D7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZJ2D7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZJ2D7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:59:20 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:64705 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZJ2D7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=eIatdK
	5SupruUMkKvV+yhsKm8/xdZ0BsSvcq50MoVc3xwXgLHEzVg8vtCOrqJ3uh16eEa1
	APEU7R+u1EQVQLaHc/Xfy2xcPQkT56iC5lUv40NxpdrxAm5utWs3OBdiTen7Q1ca
	UWGjZ8rci+Rn9D7EyI3wOf6InwWmFpOoBay+E=
Subject: Re: [PATCH 1/6 v5] Kernel DLPAR Infrastructure
From: Nathan Lynch <ntl@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256785731.26770.38.camel@pasglop>
References: <4AE8ADCF.6090104@austin.ibm.com>
 <4AE8AF4D.4030403@austin.ibm.com>  <1256785731.26770.38.camel@pasglop>
Content-Type: text/plain
Date: Wed, 28 Oct 2009 22:59:13 -0500
Message-Id: <1256788753.6279.165.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 6F5DE884-C43F-11DE-9A32-A67CBBB5EC2E-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 14:08 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-10-28 at 15:53 -0500, Nathan Fontenot wrote:
> > +	struct device_node *dn;
> > +	struct device_node *first_dn = NULL;
> > +	struct device_node *last_dn = NULL;
> > +	struct property *property;
> > +	struct property *last_property = NULL;
> > +	struct cc_workarea *ccwa;
> > +	int cc_token;
> > +	int rc;
> > +
> > +	cc_token = rtas_token("ibm,configure-connector");
> > +	if (cc_token == RTAS_UNKNOWN_SERVICE)
> > +		return NULL;
> > +
> > +	spin_lock(&workarea_lock);
> > +
> > +	ccwa = (struct cc_workarea *)&workarea[0];
> > +	ccwa->drc_index = drc_index;
> > +	ccwa->zero = 0;
> 
> Popping a free page with gfp (or just kmalloc'ing 4K) would avoid the
> need for the lock too.

Not kmalloc -- the alignment of the buffer isn't guaranteed when
slub/slab debug is on, and iirc  the work area needs to be 4K-aligned.
__get_free_page should be fine, I think.


