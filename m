Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZJOFYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZJOFYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZJOFYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:24:39 -0400
Received: from claw.goop.org ([74.207.240.146]:47797 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZJOFYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:24:38 -0400
Message-ID: <4AD6B1F0.6030904@goop.org>
Date: Wed, 14 Oct 2009 22:24:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
References: <0be3e26b-76b6-47c9-b7ab-51ed72b72b69@default>
In-Reply-To: <0be3e26b-76b6-47c9-b7ab-51ed72b72b69@default>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/09 20:26, Dan Magenheimer wrote:
> As long as we are going through the trouble of making
> this monotonic, shouldn't it be monotonically increasing
> (rather than just monotonically non-decreasing)?  The
> rdtsc instruction and any suitably high-precision
> hardware timer will never return the same value
> on subsequent uses so this might be a reasonable
> precedent to obey.  E.g.
>
> +	return ret > xen_clocksource.cycle_last ?
> +		ret : ++xen_clocksource.cycle_last;
>   

No, cycle_last isn't updated on every read, only on timer ticks.  This
test doesn't seem to be intended to make sure that every
clocksource_read is globally monotonic, but just to avoid some boundary
conditions in the timer interrupt.  I just copied it directly from
read_tsc().

    J
