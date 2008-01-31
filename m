Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYAaCXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYAaCXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYAaCX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:23:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:30002 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYAaCX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N8lCAUmLRTIcu2cOUusSXT+mvVcMzxJoLCe53SvtD4WN0iezGxTxe/nLhldTd7JBKPGx5a5cVnCeZ09U6R0Ik8g0hFNps8CEWgEAhgSChm6mvafQMrF9cGStTF21/iZGrFOeYmjjlzG6SQI4+q9Ax7TztaJlsSecvDww5ntv8C0=
Message-ID: <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
Date: Thu, 31 Jan 2008 10:23:26 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Krzysztof Piotr Oledzki" <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
In-Reply-To: <47A07FEA.3000702@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
	 <47A07FEA.3000702@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 9:47 PM, Patrick McHardy <kaber@trash.net> wrote:

> A binary dump would be more useful:
>
> tcpdump -i lo -w <outfile>
>
> and I guess Jozsef also wants "-s 0" so the full packets are included.

Attached. Again, both runs with this command to print ...

for((i=1; i<1001;i++)); do echo $i | lpr -Plp; done

In the good file (lo.good), look for this timestamp (08:38:11.818587)
when it paused then continue again at 08:38:22.477261. That's almost
11 seconds of "sleep" ... (may be a feature of TCP/IP?).

In the bad file (lo.bad), look for 08:47:55.434722 where it paused,
and then continue at
08:48:24.449176. That's 28 seconds of sleep. But, after it continued,
lpstat shows it's printing a job every 3 seconds. All 100 jobs take
approx 1400 seconds to complete as compared to under 100 seconds for
the good run.

Again, using latest linux, one with
17311393f969090ab060540bd9dbe7dc885a76d5 reverted, and the other
without.


Thanks,
Jeff.
