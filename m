Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbYITRdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbYITRdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYITRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:33:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59644 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYITRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kIruunan9PisGTzvPT/RkZtlBCBDFWx4Xd+A8sxkdwww25tUUV1Kim44sao+BhT8p3
         wgBfGQs7ywBVTq8YZvE/krwhDFECakjuwY8IZUgzKwCYUbcaSHS+imbOwJLevYk5LfWV
         Ur+8tp9mmGHFksXdPD0oHw3aWiFadQKW7MzfA=
Date: Sat, 20 Sep 2008 21:33:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christer Weinigel <christer@weinigel.se>,
       Alexey Dobriyan <adobriyan@gmail.com>, Russ Dill <russ.dill@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement
	ARRAY_SIZE().
Message-ID: <20080920173305.GE7354@localhost>
References: <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com> <20080919175544.GA3228@x200.localdomain> <48D4F519.2080509@weinigel.se> <20080920134543.GA7354@localhost> <48D50883.6040700@weinigel.se> <20080920144504.GB7354@localhost> <48D5271B.7010109@weinigel.se> <20080920171216.GD7354@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920171216.GD7354@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Sep 20, 2008 at 09:12:16PM +0400]
| [Christer Weinigel - Sat, Sep 20, 2008 at 06:38:51PM +0200]
| > Cyrill Gorcunov wrote:
| >> [Christer Weinigel - Sat, Sep 20, 2008 at 04:28:19PM +0200]
| >> ...
| >>> In my opinion, making platform_add_devices into a magic macro is   
| >>> actually worse, since the same construct (array, ARRAY_SIZE(array)) 
| >>> is  used in many places, so one would have to do the same thing over 
| >>> and  over again for every function.  In that case it's better to have 
| >>> to  learn one macro once, and the ALL_CAPITALS should make it obvious 
| >>> that  it is a macro.
| >
| >> Well, can't agree with you :) It's my _presonal_ opinion.
| >> You could define it as
| >>
| >> static inline int platform_add_devices_array(struct platform_device **devs)
| >> {
| >> 	return platform_add_devices(devs, ARRAY_SIZE(devs));
| >> }
| >
| > Won't work.  You would have to use a macro.  The above would turn into:
| >
| >      platform_add_devices(devs, 1);
| >
| > or would if the __must_be_array check didn't catch it.
| >
| >   /Christer
| >
| 
| Ah...indeed, my bad :) gcc is not that smart (yet). So there only
| the macro is possible (just forget that it will be different
| namespace scope). Anyway even having it like a macro would be
| better then hiding args.
| 
| 		- Cyrill -

ie I mean

#define platform_add_devices_array(devs) \
	platform_add_devices(devs, ARRAY_SIZE(devs))

which should satisfy the requirements. Please note that I'm not
trying to say it should be done like that - just a propose which
looks for me much better the ARRAY_AND_SIZE in context of routine
argument.

ps: i was to use macro before inline func but someone inside me
was talking - hey, use function, not macro... and I gave up :)

		- Cyrill -
