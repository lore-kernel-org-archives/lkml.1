Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXK2KBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXK2KBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXK2KAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:00:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:59176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbXK2KAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:00:50 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 29 Nov 2007 11:00:46 +0100
User-Agent: KMail/1.9.6
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de> <200711291055.02056.arnd@arndb.de>
In-Reply-To: <200711291055.02056.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711291100.46598.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I think it would be good if you could specify a default namespace
> per module, that could reduce the amount of necessary changes significantly.

But also give less documentation. It's also not that difficult to mark
the exports once. I've forward ported such patches over a few kernels
and didn't run into significant me

> obj-$(CONFIG_COMBINED) += combined.o
> combined-$(CONFIG_SUBOPTION) += combined_main.o combined_other.o
> obj-$(CONFIG_SINGLE) += single.o
> obj-$(CONFIG_OTHER) += other.o
> obj-$(CONFIG_API) += api.o
> 
> NAMESPACE = subsys                       # default, used for other.o
> NAMESPACE_single.o = single              # used only for single.o
> NAMESPACE_combined.o = combined          # all parts of combined.o
> NAMESPACE_combined_other.o = special     #    except this one
> NAMESPACE_api.o =                        # api.o is put into the global ns

I would prefer to keep that inside the source files, again for 
documentation purposes. One goal of namespace was to make something
that was previously kind of implicit explicit and the default name
spaces would work against that again I think.

-Andi
 
