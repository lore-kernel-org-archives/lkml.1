Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXFYRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXFYRAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXFYRAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:00:25 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:40140 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751458AbXFYRAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:00:23 -0400
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org>
	 <20070618044017.GW3723@sequoia.sous-sol.org>
	 <20070620171037.GA28670@sergelap.ibm.com>
	 <20070620174613.GF3723@sequoia.sous-sol.org>
	 <20070621160011.GB9913@sergelap.austin.ibm.com>
	 <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com>
	 <Line.LNX.4.64.0706241158320.12660@localhost.localdomain>
	 <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
	 <20070624220903.GB3723@sequoia.sous-sol.org>
	 <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 25 Jun 2007 12:59:29 -0400
Message-Id: <1182790769.5636.83.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 00:33 -0400, James Morris wrote:
> Convert LSM into a static interface, as the ability to unload a security 
> module is not required by in-tree users and potentially complicates the 
> overall security architecture.
> 
> Needlessly exported LSM symbols have been unexported, to help reduce API
> abuse.
> 
> Parameters for the capability and root_plug modules are now specified at 
> boot.
> 
> The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> 
> Signed-off-by: James Morris <jmorris@namei.org>
> ---

> diff --git a/security/security.c b/security/security.c
> index fc8601b..e49dae2 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -172,8 +170,5 @@ int mod_unreg_security(const char *name, struct security_operations *ops)
>  	return security_ops->unregister_security(name, ops);
>  }
>  
> -EXPORT_SYMBOL_GPL(register_security);
> -EXPORT_SYMBOL_GPL(unregister_security);
> -EXPORT_SYMBOL_GPL(mod_reg_security);
> -EXPORT_SYMBOL_GPL(mod_unreg_security);
> +/* Export required for modular use of security.h inlines */
>  EXPORT_SYMBOL(security_ops);

I think you want to eliminate that last export too, by taking the
security hooks that are called by modules into out-of-line wrapper
functions in security.c rather than directly referencing security_ops.

-- 
Stephen Smalley
National Security Agency

