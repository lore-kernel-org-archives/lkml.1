Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596Ab0AYVdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0AYVdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0AYVdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:33:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46112 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab0AYVdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:33:06 -0500
Message-ID: <4B5E0DFA.8080705@zytor.com>
Date: Mon, 25 Jan 2010 13:32:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain> <4B57A2D4.9030204@gmail.com> <20100121185544.GB11996@core.coreip.homeip.net> <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com> <20100121221701.GA15293@core.coreip.homeip.net> <20100125163433.GB31957@suse.cz>
In-Reply-To: <20100125163433.GB31957@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 08:34 AM, Vojtech Pavlik wrote:
> 
> Thus I believe that the right fix here is to figure out why the accesses
> to the ports 0x60/0x64 take a long time or forever on a Mac. Is it just
> that the kernel is timing out waiting for the i8042? Or is it something
> more sinister?
> 

In the A20 code in the setup code, I look for 0xFF coming back and
terminate the "wait for ready" loop much sooner than for other values.
0xFF is a *possible* status value, but not a very *likely* one
(especially for repeated reads), as it would represent:

parity error + receive timeout + transmit timeout + keyboard lock +
command + selftest OK + input full + output full.

	-hpa
