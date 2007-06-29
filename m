Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbXF2Vwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbXF2Vwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbXF2VvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:51:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42024 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXF2VvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:51:09 -0400
Subject: Re: how to determine if the noexec stack is defined by an
	application
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <46856F24.5060407@andrei.myip.org>
References: <46856F24.5060407@andrei.myip.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 29 Jun 2007 14:49:18 -0700
Message-Id: <1183153758.2894.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But it's running a Web service which is a combination of C code and 
> Tomcat/Java. I have no clue how to determine which portions specify a 
> noexec stack and which don't.
> 
> In case it turns out some portions do not specify a noexec stack, my 
> next question is how to get the application to create a noexec stack 
> (assume I can make that request to the developers).


like this:

$ eu-readelf -l /bin/true  | grep STACK
  GNU_STACK      0x000000 0x00000000 0x00000000 0x000000 0x000000 RW 0x4


(replace /bin/true with the binary or library you want to check)

if it says "RW" like here, it'll have non-executable stack. If it says
"RWX" or if this line is absent entirely, the stack will be executable.



