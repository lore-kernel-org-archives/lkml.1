Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXFVRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXFVRrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXFVRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:47:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbXFVRrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:47:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florin Iucha <florin@iucha.net>
Subject: Re: "upping" a semaphore from interrupt context?
Date: Fri, 22 Jun 2007 19:34:18 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070622173839.GB8398@iucha.net>
In-Reply-To: <20070622173839.GB8398@iucha.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706221934.18436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uyRtk7VlF4tJhaGdUZNP7ZHdoZDsB/AvPJ6B
 D5ekkhyelOiBDCN6fInzpVbl5Vq5Z9VqjQKa0ljhJcP3Dtmh+R
 kZtKUc07znELDbIOcn1Bw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Florin Iucha wrote:
> I am writing a USB driver for some custom hardware, and I need to
> synchronize between the user-space and the USB subsystem.  Can I
> create a semaphore and "down" it in the reader then "up" it in the
> completion handler?

yes, but you should not. The use of semaphores is not recommended
for new code, it should be replaced with either a mutex or a
completion.

> I know the completion handler runs in interrupt context so you are not
> allowed to acquire any semaphores: but can you release them?  Will the
> waiting tasks wake up after the handler and its caller returned - IOW
> will the waking up task run in interrupt context as well?

What you should use is a 'struct completion', which you can wait for
in process context and complete from interrupt context.

	Arnd <><
