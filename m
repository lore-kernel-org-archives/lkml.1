Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZJUSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZJUSev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZJUSeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:34:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZJUSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:34:50 -0400
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20091021181705.GA5218@opentech.at>
References: <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>
	 <4ADF38D5.9060100@caviumnetworks.com>
	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>
	 <4ADF3FE0.5090104@caviumnetworks.com>
	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>
	 <4ADF4982.9010306@caviumnetworks.com>
	 <1256148562.18347.3264.camel@gandalf.stny.rr.com>
	 <20091021181705.GA5218@opentech.at>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 14:34:52 -0400
Message-Id: <1256150092.18347.3294.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 20:17 +0200, Nicholas Mc Guire wrote:
> > 
> > 
> > We're not doing back traces. We need to modify the return of the
> > function being called. Note, the above functions that end with ";" are
> > leaf functions. Non leaf functions show "{" and end with "}".
> > 
> > The trick here is to find a reliable way to modify the return address.
> >
> would it not more or less be the same thing if you used -finstrument-functions
> then and provide a stub __cyg_profile_func_enter/exit initialized to an empty
> function until you replace it during tracing. This does give you an overhead
> when you are not tracing - but it would make the tracer implementation quite
> generic.

-finstrument-functions adds a substantial overhead when not tracing, and
there's no easy way to remove it. The beauty with this approach is that
-pg only adds a couple of instructions (one on x86). When tracing is
disabled, that one line is converted to a nop.

On x86, hackbench reports no difference between running with dynamic
ftrace configured but disabled (includes function graph configured) and
without it configured.

This allows function tracing to be configured in on production
environments.

-- Steve


