Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbZLGMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbZLGMXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZLGMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:23:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:59872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZLGMX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:23:28 -0500
Message-ID: <4B1CF39A.5050806@suse.cz>
Date: Mon, 07 Dec 2009 13:22:50 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: net/kbuild trees build failure
References: <20091207200317.57820f0a.sfr@canb.auug.org.au> <20091207114158.GA2428@merkur.ravnborg.org>
In-Reply-To: <20091207114158.GA2428@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.12.2009 12:41, Sam Ravnborg wrote:
> On Mon, Dec 07, 2009 at 08:03:17PM +1100, Stephen Rothwell wrote:
>> Hi Dave,
>>
>> Today's linux-next build (powerpc allyesconfig) failed like this:
>>
>> In file included from drivers/net/wireless/iwlwifi/iwl3945-base.c:57:
>> drivers/net/wireless/iwlwifi/iwl-core.h:66:30: error: linux/utsrelease.h: No such file or directory
>>
>> Caused by commit 250cce26d5d03337aec4ff8405121f026adb4a89 ("iwlwifi:
>> driver version track kernel version") from the net tree interacting with
>> commit 8e5c76aace9705b6983cfbf5eb2f2e869dab6738 ("kbuild: move
>> utsrelease.h to include/generated") from the kbuild tree.
>>
>> I applied this patch for today (and will carry it as necessary):
> 
> The right fix would be to use 'utsname()->sysname' (I think sysname
> is the right member).

->release would be the right one. One could also question why iwlwifi
needs to repeat the kernel version it was built / is running against,
but I that's not the point here :). Dave, John, can we agree that
whichever tree gets merged first, the other tree applies the one-liner?

Thanks!
Michal
