Return-Path: <linux-kernel-owner+w=401wt.eu-S1764518AbZDBVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764518AbZDBVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760942AbZDBVY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:24:27 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40934 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbZDBVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:24:26 -0400
Date: Thu, 2 Apr 2009 23:26:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       yakui_zhao <yakui.zhao@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: simplify module_param namespace
Message-ID: <20090402212625.GA8502@uranus.ravnborg.org>
References: <200903071328.28113.rusty@rustcorp.com.au> <200903110927.12792.rusty@rustcorp.com.au> <20090311145124.696b2448.sfr@canb.auug.org.au> <200903120907.20055.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904021659190.4660@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904021659190.4660@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +processor-objs	+= processor_core.o processor_throttling.o \
> +				processor_idle.o processor_thermal.o
> +ifdef CONFIG_CPU_FREQ
> +processor-objs	+= processor_perflib.o
> +endif

It would be nicer to do:
processor-y := processor_core.o processor_throttling.o
processor-y += processor_idle.o processor_thermal.o
processor-$(CONFIG_CPU_FREQ) += processor_perflib.o

Assuming processor-objs was not assinged before in this file.

	Sam
