Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYI3Htz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYI3Htz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYI3Hny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:43:54 -0400
Received: from smtp2.ono.com ([62.42.230.20]:39513 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753613AbYI3Hnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:43:53 -0400
Date: Tue, 30 Sep 2008 09:43:46 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Typo bug [Re: Linux 2.6.27-rc8]
Message-ID: <20080930094346.307ef1e5@werewolf.home>
In-Reply-To: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0cvs138 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi....

On Mon, 29 Sep 2008 15:39:09 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> So yet another week, another -rc. This one should be the last one: we're 
> certainly not running out of regressions, but at the same time, at some 
> point I just have to pick some point, and on the whole the regressions 
> don't look _too_ scary. And -rc8 obviously does fix more of them.
> 
> Most of the changes since -rc7 are pretty small, and there aren't even a 
> whole lot of them. The shortlog (appended) is just a couple of pages, and 
> the diffstat is even smaller, but since the dirstat is a dense overview, 
> I'll just put that here instead:
> 


Dealing with my Aspire One setup, I found this (so obvious I don't send a patch:)


arch/x86/kernel/cpu/mtrr/main.c:

static int __init disable_mtrr_cleanup_setup(char *str)
{
    if (enable_mtrr_cleanup != -1)
        enable_mtrr_cleanup = 0;
    return 0;
}
early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);

static int __init enable_mtrr_cleanup_setup(char *str)
{
    if (enable_mtrr_cleanup != -1)
        enable_mtrr_cleanup = 1;
    return 0;
}
early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
             ^^^^^^

Nice ;)

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
