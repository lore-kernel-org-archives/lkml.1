Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZAEPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZAEPai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZAEPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:30:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:27401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZAEPa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W7zo5vKwxeVKOdM7qnwN4Om1qkoiagBW8vn0WXMyGsCYOJquIumOKzV+IaCOdf3XSp
         RBpFX7FpYmQGRqZTK5yHvPaMoBee0jiaidgHaOoJmkbYy0xplFHfoLz4mI6VkDlx0+Vt
         Zoqn7si0B9fi6eRuDgLDwazwIAttTS505y9/4=
Date: Mon, 5 Jan 2009 18:30:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
Message-ID: <20090105153025.GH7645@localhost>
References: <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org> <20090105130836.GN496@one.firstfloor.org> <49621E6E.2010809@gmail.com> <20090105150150.GF7645@localhost> <496223C4.20307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496223C4.20307@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 05, 2009 at 04:14:12PM +0100]
| On 01/05/2009 04:01 PM, Cyrill Gorcunov wrote:
| > [Jiri Slaby - Mon, Jan 05, 2009 at 03:51:26PM +0100]
| > | On 01/05/2009 02:08 PM, Andi Kleen wrote:
| > | > +#define EARLY_BUG_ON(x) do { if (unlikely(!(x))) EARLY_BUG(); } while (0)
| > | 
| > | I think unintentionally inverted logic.
| > 
| > just second ! is missed :)
| 
| None is needed, two '!' are added in the macro itself while it passes the
| parameter to the builtin.

ah, yep :)

| 
| > | 
| > | > +#define EARLY_BUG_ON(x) do {} while(0)
| > | 
| > | Shouldn't be x referenced here?
| > |
| > 
| > but for what?
| 
| I know, core devs are sane, but e.g. for reasons such as
| 
| {'a' is used here already}
| EARLY_BUG_ON(!(a = readl(...)))
| {use 'a' again}
| 
| to stay on the safe side.
| 

I wouldn't populate this style Jiri. It become more complicated
as it should to be, agreed?

		- Cyrill -
