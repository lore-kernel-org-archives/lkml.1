Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbYEBNRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbYEBNRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764067AbYEBNQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:16:51 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:36604 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbYEBNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:16:51 -0400
Message-ID: <481B1441.1040500@isomerica.net>
Date: Fri, 02 May 2008 09:16:49 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: question about circular locking dependency
References: <481B05C9.9060103@xs4all.nl>
In-Reply-To: <481B05C9.9060103@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> I assume a serial console is the only way to capture the error messages
> of this circular locking dependency.
> Or are there alternatice methods?

You can try netconsole: see Documentation/networking/netconsole.txt for 
details on how to set it up.  It may not always work.  Obviously a 
failure in the networking code may not be reported correctly.  But it 
will try its best.

I just use netcat on a separate system to listen on a specific port and 
redirect to a file:

netcat -lu -p 6666 > logfile

This tells netcat to listen, UDP, port 6666.

Then, on the test system, I load the netconsole module with option:

netconsole=@/,@192.168.4.60/00:17:31:98:77:2f

on boot.  After this point every kernel message is logged to the logfile 
via netcat.  You can also build netconsole in and specify the options on 
the boot command line.  But if you do this obviously you need to build 
in your network card driver, as well :)

Hope that helps.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noé
                     |  http://isomerica.net/~dpn/
