Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZAHDfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZAHDfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZAHDez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:34:55 -0500
Received: from lists.laptop.org ([18.85.2.145]:50983 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbZAHDez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:34:55 -0500
Date: Wed, 7 Jan 2009 22:34:54 -0500
From: Michael Stone <michael@laptop.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Message-ID: <20090108033454.GK3164@didacte.laptop.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <1231307334-9542-2-git-send-email-michael@laptop.org> <20090107114703.GB28161@ioremap.net> <20090107210758.GH3164@didacte.laptop.org> <alpine.LRH.1.10.0901081057430.10976@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0901081057430.10976@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 12:22:17PM +1100, James Morris wrote:
>Have you considered utilizing network namespaces [1] ?  A process created 
>with a private network namespace has no network interfaces configured, 
>except loopback, which is down.  Does this do what you want?  The launcher 
>could optionally allow local IP by bringing up the loopback interface.

James,

This net-namespaces work sounds quite apropos to some of my other
projects but I'm having trouble figuring out whether it can be used to
solve my current problem. Two questions which immediately occur to me
include:

  1) As with the netfilter suggestions provided by Andi and Evgeniy, it
  seems that processes require special privileges (e.g. CAP_NET_ADMIN) in
  order to drop network privileges by means of entering a new net
  namespace. Is this correct? If so, why is it necessary or appropriate?

  2) What happens if I call unshare(CLONE_NEWNET) after I've bound some
  sockets to an address or connected some sockets to remote endpoints?

Perhaps you can help straighten me out, e.g. by pointing me at the
relevant code?

Thanks very much,

Michael
