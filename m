Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYEVSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYEVSKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbYEVSKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:10:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:11685 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbYEVSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Gp8ggh9L5q7VUjQ3+7w1Y2HkrLj+WhYGsfiU5s6iVj0k930XCU1w5GJPOvmQ7zVLglpdtyI+CZyxnq24OUsG5v9sBKtk/qnYZpmkY3x4SwBpzYfAVribw4krH/vLiB5s3OFZURiCZLCIIWyiSjqo4qOSLqvibx1/QtmqW51vuvw=
Date: Thu, 22 May 2008 23:06:24 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Jones <davej@codemonkey.org.uk>, Andres Salomon <dilinger@queued.net>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080522190624.GA12322@martell.zuzino.mipt.ru>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080502190949.GA30270@uranus.ravnborg.org> <20080521164703.61c7d715@ephemeral> <20080521211139.GA22591@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521211139.GA22591@codemonkey.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:11:39PM -0400, Dave Jones wrote:
> On Wed, May 21, 2008 at 04:47:03PM -0400, Andres Salomon wrote:
> 
>  > > 3) Implement newsymbolsconfig (any better name?)
>  > >    Shall list all new symbols and shall not write
>  > >    any config
>  > 
>  > I'm not sure I see the point of #3.
> 
> It's something we've had in Fedora kernels forever, because
> when rebasing to a new upstream version the process becomes
> 
> make newsymbolsconfig
> take list of symbols, and make decisions on them
> make oldconfig
> 
> 
> without it, the process would be..
> 
> make oldconfig
> note new symbol, make decision
> make oldconfig
> note a 2nd new symbol, make decision
> make oldconfig
> note a 3rd new symbol..
> make oldconfig..
> you get the idea.

It's actually

	make oldconfig
	[note new symbol, make decision]
	[note new symbol, make decision]
	[note new symbol, make decision]
	make

so the number of decisions and invocations are the same.

> The way we have it isn't perfect, (adding a new symbol may unhide
> another set of new symbols), but it reduces the number of iterations
> needed dramatically.

