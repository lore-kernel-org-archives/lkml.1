Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZINGnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZINGnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZINGnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:43:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZINGnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DygF3r4/10LQ94QctducxZrt4ZYYt8CSirbdZqmx2VfcThfL2hq8WGT2fQem9uiDXd
         nvbwuGOnUn+YcPAUXpnVC+9WMVVENvOIIvsiip42ekQGVahe+JMO5wF+g5Bd5quld/Rr
         uB8ZO3FjyXTrAW9yuEBjcHkToa6wm0hMP6Kjc=
Date: Mon, 14 Sep 2009 10:43:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Ingo Molnar <mingo@elte.hu>,
       Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: apic: convert BUG() to BUG_ON()
Message-ID: <20090914064351.GA4190@lenovo>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com> <20090912180527.GA4893@lenovo> <1252779641.28368.81.camel@desktop> <alpine.LFD.2.00.0909122336330.12448@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909122336330.12448@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sat, Sep 12, 2009 at 11:51:40PM +0100]
| On Sat, 12 Sep 2009, Daniel Walker wrote:
| 
| > For one it condenses duplicate code (i.e. the if()). If the BUG_ON()
| > macro gets updated with something new, all the users get the updates
| > automatically. The other thing is your re-using potentially more
| > advanced code that's inside the macro. In this case it's fairly trivial,
| > 
| > #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
| > 
| > So we're getting the benefit on the new "unlikely" in the apic code.
| > unlikely/likely calls will usually allow the compiler to create smaller,
| > and or, more optimized code. 
| 
|  For non-x86 platforms the use of the BUG_ON() macro may result in more 
| efficient code GCC may not be able to optimise to with if (...) BUG();.  
| For example the macro may expand to inline assembly with a conditional 
| trap instruction GCC would not emit for an if () clause.  While GCC does 
| have a __builtin_trap() intrinsic that could be optimised if alone in a 
| conditional block, such usage may not be frequent enough for a dedicated 
| optimisation to be provided and build-time efficiency of the compiler does 
| matter too, so such an optimisation might be of too questionable a value 
| to incur an additional performance hit for the compiler.
| 
|  Just a general note on patches of this kind, or to put it short, yes I 
| agree it's a good idea.
| 
|   Maciej
| 

Actually this is quite a good candidate for commit message :)

	-- Cyrill
