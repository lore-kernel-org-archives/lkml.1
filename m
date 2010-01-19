Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074Ab0ASPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0ASPoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938Ab0ASPoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:44:54 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:64780 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0ASPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iDG3ijwaDCljOXk4e46b51gBi3yhYvTPr9/lnDwLJrakj7bAOrzszlOOfUyzKa8yyq
         S4nkME4Opwmm16tdMZm3r+tSSnGUxMMhoKDiv813V9pBhDQJ+BH4Dnys2zLmvKCRtOQk
         DZir7mspIDxXTW0IkN9E1LXdCiP8FpPDOSm28=
Message-ID: <4B55D372.4020807@gmail.com>
Date: Tue, 19 Jan 2010 10:44:50 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: netdev <netdev@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
References: <4B54CDE5.3070100@simon.arlott.org.uk>    <4B5578A5.50705@gmail.com> <dad314e12c5750b1b5d70c3ea3c6f6134b8fa0f3@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <dad314e12c5750b1b5d70c3ea3c6f6134b8fa0f3@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> On Tue, January 19, 2010 09:17, William Allen Simpson wrote:
>> 2) There certainly *can* be data on SYN.  That code is already in
>> 2.6.33....
> 
> I could change the comment too, but the same logic applies when
> there is data and no MSS option - the packet can't be increased
> in size if it would then exceed 576 bytes and/or the destination
> MTU.
> 
Please change the comment.

If there is no MSS option, it should *not* be added, under *ANY*
circumstances.  That violates the end-to-end arguments (some call
them principles).

MSS isn't about the _destination_ MTU, it's about the *source*.
If you cannot guarantee you know the source MTU, there's no basis
for deciding the MSS.

While I understand that sometimes it's useful to reduce (never,
NEVER, *NEVER* increase) the MSS as a packet goes into a tunnel
(because there are problems in some NAT'd networks with determining
Path MTU via ICMP), I'm not aware of any circumstance where the MSS
would need to be reduced below 536.

I'm having some difficulty figuring out how this code originated --
with a nice log entry explaining the exact manufacturer's device
and network topology that the contributor had in mind?


> If it's possible to know that the packet can have an additional
> option added without exceeding MTU then this could be changed.
> The data part would need to be moved to make space at the end of
> the header.
> 
No options should be added to TCP in a router -- ever!
