Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZBWDRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZBWDRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 22:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZBWDRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 22:17:39 -0500
Received: from web34408.mail.mud.yahoo.com ([66.163.178.157]:29210 "HELO
	web34408.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751356AbZBWDRj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 22:17:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=byNzyonl8JIbsNlFcWAfDh04v0uAV6bS915L9PzQQPWhYbSvnfX6hSimS9hodewc4OG0CrZScp9NdINwUu0QM88bupchJmq3ME6Tm+ZquVoX9BURd+0XTAU752cgkTso2rY3dug3Nu2VqIa9JefSmzUYdCAHbz8MwQ0n0KcmVIk=;
X-YMail-OSG: BEhKghYVM1kTsfr5tJQa8vnD1Wr6SaPK7T.mExXqIZs6cYqObEwU3RMjgxI9kZMRfptCX6oABuCkfGbP4Sw07sdahKm1qF8OWOoscy6Y519DnPS2_K.fYrRod.zfdTlFJhbyitBeGxtdTWneAUVM1MM5ZUfdUHdR3mQsMGCVJRrjBaHs8fcTl5SZrH5nEAbbbbXN2Q0R.ry.F.2fB3KST6Iqcpic8Q--
X-Mailer: YahooMailWebService/0.7.289.1
Date: Sun, 22 Feb 2009 19:17:38 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: Is interrupt priority supported ?
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
In-Reply-To: <499DFF79.6090404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <260723.67629.qm@web34408.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It doesn't really work that way in Linux. Normally
> disabling interrupts is all or nothing. Whether or not other
> devices can cause interrupts during an interrupt handler
> execution by default is a bit platform-dependent, I think
> (unless the driver requests IRQF_DISABLED which requests
> that other interrupts should not run).
> 
> Normally in Ethernet drivers these days only very minimal
> processing is done during the interrupt handler, the rest is
> deferred to softirq context which runs with interrupts
> enabled so other interrupts can happen. That's not to
> say that all Ethernet drivers are so well-behaved, however,
> especially if they haven't been updated to use NAPI. (In
> the NAPI case, the driver disables further interrupts from
> the device until the softirq is able to run and process the
> packets.) In your case it seems likely that yours is not
> behaving so well, as one would expect the interrupt handler
> to complete in less than the time  it takes one character to
> arrive on the serial port..

Interesting, thanks for all the info, I had to research before responding.
It appears network cards was one of the reasons for the softirqs, there is two definitions for network cards in softirqs.
Yes, I looked the DM9000 driver and saw the data being read inside the interrupts so... you are right, that driver was not changed to use softirqs.
I also saw how the IRQF_DISABLED flag works.
I Think using this flag is the way to go for my 4 byte FIFO uart, I would say a 4 byte FIFO is critical enough to be read inside an interrupt.
I know it is kind of strange, the correct way it would be to fix the Ethernet driver and instead of doing that I will not allow any other interrupt inside the uart interrupt, which degrades the system somehow.
What do you think ?
Do you know if the same kind of problem I am having with Ethernet is also seen with USBs ?

Thanks again for all your response.



      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
