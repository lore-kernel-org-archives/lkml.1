Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZERIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZERIWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZERIWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:22:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:48688 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZERIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=umeo5vwxFrhjBaiRl6c4MLapggspZXBUiempqTtuGHVJC7bsiH7qQNZlgmOj2s2FKP
         2pBdmsLQsvmHqGQPW2lG7rYNMFgEgMYWpiAhpFueBb9J1tw1gWXVEv2njQnOMWhUv0zB
         z6LcoOIzCOzWtSIUlhiD2mELIlhFKfbjwmsik=
Message-ID: <4A111A85.6030508@gmail.com>
Date: Mon, 18 May 2009 10:21:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-kbuild@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Kconfig: fix problem in HID menu
References: <20090517175617.81323cc1.krzysztof.h1@wp.pl>
In-Reply-To: <20090517175617.81323cc1.krzysztof.h1@wp.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2009 05:56 PM, Krzysztof Helt wrote:
> Following syntax does not work properly if there is an options FOO2 depending on the FOO:
> 
> config FOO
> 	tristate "Foo" if EMBEDDED
> 	depends on FUD
> 	default !EMBEDDED
> 
> config FOO2
> 	bool "Foo2"
> 	depends on FOO
> 
> If the EMBEDDED is not selected the FOO option is selected
> and it cannot be unselected.

Uhuh, but that's correct behaviour. We don't want to bother user with
tons of drivers unless he is compiling for embedded. Or am I missing
something?

> The change of the FOO definition:
> 
> config FOO
> 	tristate "Foo" 
> 	depends on EMBEDDED && FUD
> 	default !EMBEDDED
> 
> fixes the issue.

This does something different. You offer regular user to turn it off and
defaults to n for embedded. This is not what we want, I suppose.

> This is likely a bug in Kconfig tool.

In that case, you want to fix the tool, not the configs.
