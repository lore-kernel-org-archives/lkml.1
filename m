Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYARF63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYARF63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYARF6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:58:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:50506 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYARF6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=btzBqnP4GOh6sFh5m7oBHEAMSaFDRadzn5IB4SKR/xtN6bY+oF6F/TbyBXwH1U/ALP6NtboYpl3eEsR4gw4RRxF/QVZN6kmAW/+njiLU6ALSXA7ocm1AoQwY61bzLctHlFGveLhs8sifsTUVsh7nevMfFhkylpcK4JuI+lupYX8=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: setting jiffies as the clocksource stops time
Date: Fri, 18 Jan 2008 11:41:55 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200801170209.42138.balajirrao@gmail.com> <1200518450.18731.129.camel@imap.mvista.com> <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181141.55837.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 04:04:33 am Jan Engelhardt wrote:
> 
> On Jan 16 2008 13:20, Daniel Walker wrote:
> >On Thu, 2008-01-17 at 02:09 +0530, Balaji Rao wrote:
> >> Hi,
> >> 
> >> When i set jiffies as the current_clocksource, date(1) tells me
> >> that wallclock time has stopped, and soon after that, the system
> >> becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
> >> 
> >> I wonder how can jiffies be used as a clocksource.. Its value
> >> depends on the tick and when we turn off ticks, we would stop
> >> incrementing jiffies and when we come come out of idle, we update
> >> the jiffies by reading the current_clocksource which now is
> >> 'jiffies', and hence jiffies wouldn't get updated. Could this be
> >> the explanation ?
> >
> >Your right, It can't be used as a clocksource with nohz , and the system
> >will refuse to automatically switch to it ..
> 
> I think that manually changing to jiffies by echoing into sysfs
> should also be prohibited.
> 
Yea, right. But why not unregister jiffies as a clocksource itself when we get into NO_HZ ? I think it's much cleaner 
provided it has no other consequences.

