Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbXLNQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbXLNQ6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbXLNQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:58:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbXLNQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:58:03 -0500
Date: Fri, 14 Dec 2007 11:56:33 -0500
From: Dave Jones <davej@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Adrian Bunk <bunk@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: Print taint info in more places.
Message-ID: <20071214165633.GA2825@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matt Mackall <mpm@selenic.com>, Adrian Bunk <bunk@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de> <20071214013041.GH22304@redhat.com> <20071214153844.GS17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214153844.GS17536@waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 09:38:44AM -0600, Matt Mackall wrote:
 > On Thu, Dec 13, 2007 at 08:30:41PM -0500, Dave Jones wrote:
 > >  #ifndef HAVE_ARCH_BUG
 > >  #define BUG() do { \
 > > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 > > +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
 > > +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
 > >  	panic("BUG!"); \
 > >  } while (0)
 > 
 > Might as well make this inline too, no?

Maybe.

 > > +void out_of_line_warnon(char *file, unsigned int line, const char *func);
 > 
 > How about __warn_on?

I'm easily swayed :)

 > > +void out_of_line_warnon(char *file, unsigned int line, const char *func)
 > 
 > Might as well make *file const too.

ok

 > > diff --git a/kernel/panic.c b/kernel/panic.c
 > > index 6f6e03e..198fc58 100644
 > > --- a/kernel/panic.c
 > > +++ b/kernel/panic.c
 > > @@ -173,6 +173,7 @@ const char *print_tainted(void)
 > >  		snprintf(buf, sizeof(buf), "Not tainted");
 > >  	return(buf);
 > >  }
 > > +EXPORT_SYMBOL(print_tainted);
 > 
 > Looks like you've got two patches here..

no, up top we added a print_tainted() call to BUG()
BUG() gets used in modules == needs its ancillary functions
also exported.

	Dave

-- 
http://www.codemonkey.org.uk
