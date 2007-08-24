Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXHXQcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXHXQcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbXHXQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:31:56 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:65015 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbXHXQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:31:55 -0400
Date: Fri, 24 Aug 2007 12:31:43 -0400
To: <alan@lxorguk.ukuu.org.uk>, <jesper.juhl@gmail.com>
Cc: <lists-receive@programmierforen.de>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: Re: Ideas on column length in kernel "problem"?
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070824163149.B7636C381C@mailserver10.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Aug 2007 07:07:54 -0400 Jesper Juhl 
<jesper.juhl@gmail.com> wrote:
>On 24/08/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > I think this is also a matter of conding style. 
>Documentation/CodingStyle says:
>> >
>> > "The limit on the length of lines is 80 columns and this is a 
>hard limit."
>>
>> As has repeatedly been stated this is a bug in 
>Documentation/CodingStyle and bears no resemblence to reality.
>>

Quite the hornet's nest I've stirred up -- I'm not trying to rock 
the boat, just trying to row.

Meanwhile, I ran a couple programs against the 2.6.22.1 source to 
get some statistics on the source in the linux kernel tree to 
understand what 'reality' is:

Number of files -- 23742
Number of lines > 80 columns:  247057
Number of lines > 90 columns:  127016
Number of lines > 100 columns: 21

The *winner* at 482 columns is a commented out line in

/linux-2.6.22.1/drivers/pci/hotplug/ibmphp_ebda.c 440 //		debug 
("rio_node_id: %x\nbbar: %x\nrio_type: %x\nowner_id: 
%x\nport0_node: %x\nport0_port: %x\nport1_node: %x\nport1_port: 
%x\nfirst_slot_num: %x\nstatus: %x\n", rio_detail_ptr->rio_node_id, 
rio_detail_ptr->bbar, rio_detail_ptr->rio_type, rio_detail_ptr-
>owner_id, rio_detail_ptr->port0_node_connect, rio_detail_ptr-
>port0_port_connect, rio_detail_ptr->port1_node_connect, 
rio_detail_ptr->port1_port_connect, rio_detail_ptr->first_slot_num, 
rio_detail_ptr->status);

So I think updating the text in coding style one way or another is 
a good thing since there are ~248k exceptions to the style rule...

I can make the bins + scripts I used to gather this and output of 
this run available if anyone is interested.

However, this isn't the whole story.. one of the side effects of 
the patch system through email clients are that the function name 
in the 'git diff' (or comparable) output can tack on 20-25 columns 
of header and further cause wordwrap strife and bring more patches 
into this problem.  It *appears* that many maintainers are pretty 
good at recognizing this and purging portions of the function names 
when forwarding them around, but it's still a bigger and common 
'problem' for the wordwrapping clients.

Example: 
@@ -189,6 +189,9 @@ static __devinit int ixp4xx_pata_probe(struct 
platform_device *pdev)

Common advice appears to be to get smtp working on gmail, and I 
thank the list for their suggestions.  If I get one/two ways 
working that are compliant for patch submittal w/o wordwrap (et al) 
I'll start a 'howto' from my notes on yahoo and gmail/smtp setup 
and post that up on the interweb.

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

