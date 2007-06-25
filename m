Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXFYEs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXFYEs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXFYEst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:48:49 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:45050 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXFYEst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:48:49 -0400
Message-ID: <467F492B.6000002@vc.cvut.cz>
Date: Sun, 24 Jun 2007 21:48:43 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <Line.LNX.4.64.0706241158320.12660@localhost.localdomain> <Line.LNX.4.64.0706241653490.14183@localhost.localdomain> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
In-Reply-To: <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> Convert LSM into a static interface, as the ability to unload a security 
> module is not required by in-tree users and potentially complicates the 
> overall security architecture.

Hello,

> -module_param(debug, bool, 0600);
> -MODULE_PARM_DESC(debug, "Debug enabled or not");
> +static int __init root_plug_debug(char *str)
> +{
> +	debug = simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +__setup("root_plug_debug=", root_plug_debug);

is this necessary?  What about just documenting 
root_plug.{vendor_id,product_id,debug}, so it won't break existing 
root_plug users (if there are any) ?  I thought that typed 
module_param() is prefered over untyped __setup()...

						Thanks,
							Petr


