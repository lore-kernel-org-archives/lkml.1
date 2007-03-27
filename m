Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXC0OMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXC0OMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXC0OMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:12:20 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:42921 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXC0OMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:12:19 -0400
Date: Tue, 27 Mar 2007 10:12:17 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Sami Farin <safari-kernel@safari.iki.fi>
cc: Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: oprofile / selinux / security_port_sid
In-Reply-To: <20070327135433.xh5mtwgey3pr7u3r@m.safari.iki.fi>
Message-ID: <Line.LNX.4.64.0703271005460.21437@d.namei>
References: <20070327100653.vtmuy64kgkikydlx@m.safari.iki.fi>
 <1175002823.3864.301.camel@moss-spartans.epoch.ncsc.mil>
 <20070327135433.xh5mtwgey3pr7u3r@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, Sami Farin wrote:

> On Tue, Mar 27, 2007 at 09:40:23 -0400, Stephen Smalley wrote:
> > On Tue, 2007-03-27 at 13:06 +0300, Sami Farin wrote:
> > > is there room for improvement in security_port_sid() ?
> > 
> > Yes, lots of room.  Also, it won't get called per-packet if you enable
> > secmark (echo 0 > /selinux/compat_net or boot with selinux_compat_net=0
> > or build with SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT), although that
> > may require updating your policy.
> 
> Hmm, test was done with
> CONFIG_NETWORK_SECMARK=y
> CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
> and /selinux/compat_net = 0

Even with this setting, you'll be hitting security_port_sid() via 
connect(2) and bind(2).  We need to fix it.



- James
-- 
James Morris
<jmorris@namei.org>
