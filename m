Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXLFUy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXLFUy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXLFUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:54:48 -0500
Received: from ns.suse.de ([195.135.220.2]:38086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXLFUys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:54:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 1/19] unify desc_struct
Date: Thu, 6 Dec 2007 21:54:39 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com>
In-Reply-To: <11969578092869-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062154.40075.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/*
> + * FIXME: Acessing the desc_struct through its fields is more elegant,
> + * and should be the one valid thing to do. However, a lot of open code
> + * still touches the a and b acessors, and doing this allow us to do it
> + * incrementally. We keep the signature as a struct, rather than an union,
> + * so we can get rid of it transparently in the future -- glommer
> + */
> +#define raw_desc_struct struct { unsigned int a, b; }
> +#define detailed_desc_struct                                   \
> +  struct {                                                       \
> +	u16 limit0;                                             \
> +	u16 base0;                                              \
> +	unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;    \
> +	unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;\
> +  }

The standard clean way to do this is with a anonymous union.

-Andi
