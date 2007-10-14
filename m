Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXJNXO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXJNXO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763690AbXJNXOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:14:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51135 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760888AbXJNXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YKZP0FxRPR2LYeJuwUwrSIAe0T2mnubW5bcl1t3tkKj1ItHBmpXd57LyyGXYyy8/uTo1Db1NYBZyG+O9gKBzLH9/yg2aUstoqAjyZECh9ZllT8YpMYihuEbpMMvCoQEl3aXP28xdlkmSPaLpKr5No2e6AYJCX1r/GfrpEPUM2vM=
Date: Mon, 15 Oct 2007 01:13:58 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 7 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071014231358.GA5565@Ahmed>
References: <47124EBE.5090303@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47124EBE.5090303@schaufler-ca.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

On Sun, Oct 14, 2007 at 10:15:42AM -0700, Casey Schaufler wrote:
> 
> +
> +CIPSO Configuration
> +
> +It is normally unnecessary to specify the CIPSO configuration. The default
> +values used by the system handle all internal cases. Smack will compose CIPSO
> +label values to match the Smack labels being used without administrative
> +intervention. 
>

I have two issues with CIPSO and Smack:

1-

Using default configuration (system startup script + smacfs fstab line), system
can't access any service outside the Lan. "ICMP parameter problem message" always
appear from the first Wan router (traceroute + tcpdump at [1]).

Services inside the LAN can be accessed normally. System can connect to a Lan
Windows share. It also connects to the gateway HTTP server easily.

After some tweaking, I discovered that using CIPSOv6 solves all above problems:
$ echo -n "NLBL_CIPSOv6" > /smack/nltype

Is this a normal behaviour ?

2-

> 4. Any access requested on an object labeled "*" is permitted.
[...]
> +Unlabeled packets that come into the system will be given the
> +ambient label.

Default conf let the ambient attribute = _ which works fine. Setting ambient = *
stops all external (non lo) network traffic. Did I miss another use of "ambient"
or this is a normal behaviour ?.

> +Administration
> +
> +Smack supports some mount options:
> +
> +	smackfsdef=label: specifies the label to give files that lack
> +	the Smack label extended attribute.
> +

Although using smackfsdef=* as a mount option, all my system files have the floor
attribute. Most of the /dev files have the * attribute though.


[1]

traceroute to google.com (64.233.187.99), 30 hops max, 40 byte packets
 1  host-196.218.207.17.tedata.net (196.218.207.17)  1.976 ms  1.850 ms  2.127 ms
 2  DOKKI-R03C-GZ-EG (163.121.170.78)  27.429 ms  28.091 ms  23.336 ms

Here's the tcpdump for accessing google.com:

22:51:26.008883 IP host-196.218.207.18.tedata.net.54011 > host-196.218.207.17.tedata.net.domain:  11001+ A? google.com. (28)
22:51:26.011066 IP host-196.218.207.18.tedata.net.45317 > host-196.218.207.17.tedata.net.domain:  44913+[|domain]
22:51:26.052154 IP host-196.218.207.17.tedata.net.domain > host-196.218.207.18.tedata.net.54011:  11001 3/0/0 A py-in-f99.google.com,[|domain]
22:51:26.052700 IP host-196.218.207.18.tedata.net.57180 > py-in-f99.google.com.www: S 282373541:282373541(0) win 5840 <mss 1460,sackOK,timestamp 741383 0,nop,wscale 5>
22:51:26.090608 IP host-196.218.207.17.tedata.net.domain > host-196.218.207.18.tedata.net.45317:  44913 1/0/0 (89)
22:51:26.091473 IP host-196.218.207.18.tedata.net.34417 > host-196.218.207.17.tedata.net.domain:  49202+[|domain]
--> 22:51:26.105443 IP DOKKI-R03C-GZ-EG > host-196.218.207.18.tedata.net: ICMP parameter problem - octet 20, length 48

Best Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
