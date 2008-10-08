Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYJHAaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYJHAaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYJHA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:29:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:44087 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYJHA36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:29:58 -0400
Message-ID: <48EBFEE5.7010401@caviumnetworks.com>
Date: Tue, 07 Oct 2008 17:29:25 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: Re: [PATCH 1/4] serial: 8250 driver replaceable i/o functions.
References: <48EBF426.9080500@caviumnetworks.com> <48EBF56D.3030203@caviumnetworks.com> <48EBFAFC.3020501@zytor.com>
In-Reply-To: <48EBFAFC.3020501@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2008 00:29:25.0944 (UTC) FILETIME=[EB202B80:01C928DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Daney wrote:
>> /* sane hardware needs no mapping */
>> -static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
>> +static inline int map_8250_in_reg(struct uart_port *p, int offset)
>> {
>> -    if (up->port.iotype != UPIO_AU)
>> +    if (p->iotype != UPIO_AU)
>>         return offset;
>>     return au_io_in_map[offset];
>> }
> 
> With your changes, these functions cannot be called with p->iotype != 
> UPIO_AU anymore, correct?  So there is no need for this test...
> 

I think you are probably correct.  However, with the patch it is 
possible to move all this target specific code out of the driver.  So if 
the patch is accepted, a better follow up would be to get rid of the 
UPIO_AU things altogether.

I gave an example of how that could be done with UPIO_TSI here:

http://marc.info/?l=linux-serial&m=122333633802691&w=2

David Daney
