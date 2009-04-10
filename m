Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZDJGZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZDJGZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZDJGZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:25:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZDJGZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:25:27 -0400
Date: Fri, 10 Apr 2009 00:24:35 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: usb_mon oops Re: tcpdump crashes 2.6.29.1 (and 2.6.29-rc5)
Message-Id: <20090410002435.52794220.zaitcev@redhat.com>
In-Reply-To: <18910.46709.707557.135033@stoffel.org>
References: <18906.49779.243047.207639@stoffel.org>
	<20090407120022.GA6519@ff.dom.local>
	<18907.28788.965069.573489@stoffel.org>
	<20090407130403.e0061a8d.zaitcev@redhat.com>
	<18908.42166.404232.721757@stoffel.org>
	<20090408232344.afed8103.zaitcev@redhat.com>
	<18910.46709.707557.135033@stoffel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 23:01:09 -0400, "John Stoffel" <john@stoffel.org> wrote:

> Any suggestions of a known good state I should start bisection from?

No suggestions, sorry. The part of usbmon that peeks at DMA-ed data
wasn't touched since December 2006. It worked fine since then,
your oops is the first. So, I don't expect bisection to help.
At best you're going to find the commit where uvcvideo was merged.

The right way forward is to deduce what's going on, IMHO. Maybe
usbmon is trying to take an address in the GART aperture and convert
it into a struct page. Or the direction in URB mismatches endpoint.
Or any number of other things.

I'm working on it, but I'm not done with puzzling out the dmesg
you sent me, sorry again.

-- Pete
