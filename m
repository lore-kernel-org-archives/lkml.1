Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYCQSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYCQSRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYCQSRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:17:40 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:37300 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYCQSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:17:39 -0400
Message-ID: <47DEB5B9.4030905@alcatel-lucent.com>
Date: Mon, 17 Mar 2008 13:17:29 -0500
From: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Organization: Lucent Technologies
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.0.1) Gecko/20020823 Netscape/7.0 (CK-LucentTPES)
X-Accept-Language: sr, hr, en, zh, zh-cn, zh-hk, z
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
References: <47C6FA2A.5030302@alcatel-lucent.com>	<20080228201926.558c4e7c@core>	<47D97DF7.8000702@alcatel-lucent.com>	<20080315133426.1f48c99c@the-village.bc.nu>	<47DE9FB0.5030801@alcatel-lucent.com> <20080317173021.28e6fd97@core>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I see. So, it would have to be some malicious application running together
with the server (i.e. on the same CPU). I do see now why you said it would be
very very hard to make this happen.

Still, it would be nice to introduce SO_REUSEPORT socket options so secure
servers (who happen to be clients as well) can re-use ports when necessary.

Another option would be to check if port re-use is happening inside same
application and allow it. That may make half of the folks happy, so I am not
sure if I like it as much as I like SO_REUSEPORT option.

Thanks,
Neb


On 3/17/2008 12:30 PM, Alan Cox wrote:
> On Mon, 17 Mar 2008 11:43:28 -0500
> Nebojsa Miljanovic <neb@alcatel-lucent.com> wrote:
> 
> 
>>Alan,
>>thanks. With that additional INFO, I was able to find detailed description of
>>this denial of service attack (attached below).
>>Just to clarify. Having this port re-use check prevents folks from launching
>>this attack as opposed to being victim of it?
> 
> 
> Different issue. I can hijack a connection.
> 
> Imagine I have a server bound to *.5000, and someone is about to connect.
> If on the server box I am able to bind and issue a connect outwards
> matching the inbound connection I will get the connection not the server.


