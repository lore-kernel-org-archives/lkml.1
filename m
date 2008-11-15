Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKOEhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKOEhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYKOEhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:37:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:28097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYKOEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=v6UeyqVT5xZwNKT94e7u4RJA+b/V9/yfAk/pZXbC44pv14kSUATws3XRMMPvl3Hto1
         ZXcfHxHQXge0ZuQyRuemtAwus7Ul/DgJ/LAP2/EnS73zkdFkgfS0dI2jokd0HpxcXn8r
         MsCceVXtvFac2f1LNEursfXSRX7g98i9I2G1k=
Message-ID: <f9be06770811142037v794cf4f8w7a82ab45c0f3820c@mail.gmail.com>
Date: Fri, 14 Nov 2008 23:37:06 -0500
From: "Karl Pickett" <karl.pickett@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: tcp_tw_recycle broken?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey.  Developing a http proxy on fedora 9 (2.6.25) and running into a
strange issue.

Having the proxy set up and tear down 6000 tcp connections a second to
the same test server ip and port,
it quickly blows up (5 seconds) due to all 30000 ephemeral ports going
to TIME_WAIT.
setting tw_recycle=1 fixed the problem, and there are never more than
a couple hundred ports in TIME_WAIT.

BUT...

Changing the load test to alternate between two test server ips, it
blows up.  Connect: can't assign requested address. (note I am not
binding before hand, I tried
and binding first to port 0 made no difference - it just blows up then
during the bind).

And there are ~28K ports in TIME_WAIT.  For example:

proxy_ip:30000 load_test_1:8080 TIME_WAIT
proxy_ip:30000 load_test_2:8080 TIME_WAIT
...
but most are not duplicates of the same local port.


What. The.  Heck.

So short of rebuilding the kernel with time_wait as 1 second, is there
any other way not to brick my proxy?

--
Karl Pickett

--
Karl Pickett
