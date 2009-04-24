Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZDXVXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZDXVXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZDXVWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:22:54 -0400
Received: from ppp-110-77.adsl.restena.lu ([158.64.110.77]:54076 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZDXVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:22:53 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Apr 2009 17:22:53 EDT
Date: Fri, 24 Apr 2009 23:16:33 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Alexander V. Lukyanov" <lav@netis.ru>, linux-kernel@vger.kernel.org,
       <netdev@vger.kernel.org>
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090424231633.2dc051aa@neptune.home>
In-Reply-To: <m1hc0fuevi.fsf@fess.ebiederm.org>
References: <20090422055735.GA4334@night.netis.ru>
	<m1hc0fuevi.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 April 2009 ebiederm@xmission.com (Eric W. Biederman) wrote:
> "Alexander V. Lukyanov" <lav@netis.ru> writes:
> 
> > Eventually I have an increased load average without apparent reason.
> > When I reboot the server in such a case, I get infinitely repeating
> > messages on the console:
> >
> > unregister_netdevice: waiting for eth0.2 to become free. Usage
> > count = 4
> >
> > eth0.2 is a vlan interface, eth0 is 02:00.0 Ethernet controller:
> > Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
> > Ethernet controller (rev 01)
> 
> CC: netdev where someone might have a better clue.
> 
> Infinitely repeating unregister_netdevice messages means something
> isn't releasing it's reference count to your network device.
> 
> There really isn't enough information in your email to figure out
> what you were doing that, or what piece of code triggered this.


A few I similar cases I have encountered are related to:
  vlan, netconsole

If you attempt to rmmod the driver of a network interface for which
you have a vlan or netconsole setup on top of you end up with this
kind of lock.

At least the two above do not react of removal attempt notifications
and thus keep the network device referenced.

Bruno
