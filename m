Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYG3OyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYG3OyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYG3Ox6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:53:58 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:5294 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYG3Ox5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=RrGL4RcZtAUDn5xngVi1/nY4QIXP5ZP4kEY20Q5KGUkAOb5NxpXU84QYYG1N5GFtbs
         UW5KGL0unumetxRMn83/PJ9pg0t2n4LXMLwdi4q4ebBaZobZnXtCIr/oryBeQSynzhPF
         DgT3TQe6gDt8R6/TVaXWDtWJ7e7CIuRwK4yY0=
Message-ID: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
Date: Wed, 30 Jul 2008 16:53:57 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: iptables, NAT, DNS & Dan Kaminsky
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

as you are very likely all aware, Dan Kaminsky uncovered a major exploit
in RFC-compliant DNS caching servers the successful execution of which
relies on port prediction/guessing.

After quite some research, I have come up with the following facts which
I want to cross-check with you guys so I can be _sure_.


1) The --random target for SNAT exists since 2.6.22 to allow 'fixing' of
broken DNS servers in your NATted LAN along the lines of

iptables -t nat -I POSTROUTING 1 -p udp -s 1.2.3.4 --dport 53 -j SNAT \
--to 1.2.3.4 --random

Is that correct?


2) Unless there is a collision, the original UDP source ports for
requests are kept the same. I.e. boxes within the NATted LAN which use
random UDP ports are secure and neither the 2.4.x nor the 2.6.x series
of kernels will make those ports predictable while NATting the packets.
Is that correct?


3) Ever since a commit that went into 2.6.24 [1], UDP ports that are
NATted are randomized by the NATting forewarder, anyway. This means that
any DNS lookup made from within a NATted LAN secured with iptables to a
DNS server outside of said NAT is secure by default.
Is that correct?


Thanks for any and all input. I am sure many people would like
clarification on those points.

Richard


[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=32c1da70810017a98aa6c431a5494a302b6b9a30
