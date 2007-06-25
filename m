Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXFYE7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXFYE7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXFYE6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:58:55 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:45805 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXFYE6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:58:52 -0400
Date: Mon, 25 Jun 2007 00:58:48 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Petr Vandrovec <vandrove@vc.cvut.cz>
cc: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
In-Reply-To: <467F492B.6000002@vc.cvut.cz>
Message-ID: <Line.LNX.4.64.0706250057350.16074@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org>
 <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com>
 <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com>
 <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com>
 <Line.LNX.4.64.0706241158320.12660@localhost.localdomain>
 <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
 <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
 <467F492B.6000002@vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Petr Vandrovec wrote:

> > -module_param(debug, bool, 0600);
> > -MODULE_PARM_DESC(debug, "Debug enabled or not");
> > +static int __init root_plug_debug(char *str)
> > +{
> > +	debug = simple_strtol(str, NULL, 0);
> > +	return 1;
> > +}
> > +__setup("root_plug_debug=", root_plug_debug);
> 
> is this necessary?  What about just documenting
> root_plug.{vendor_id,product_id,debug}, so it won't break existing root_plug
> users (if there are any) ?  I thought that typed module_param() is prefered
> over untyped __setup()...

I didn't know module_param was preferred.

The idea was that root_plug is example code, and should do the typical 
thing, which I thought would be __setup.

I can easily change it if needed.


-- 
James Morris
<jmorris@namei.org>
