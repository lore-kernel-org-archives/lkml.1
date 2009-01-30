Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZA3BMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZA3BMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZA3BMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:12:10 -0500
Received: from n7a.bullet.mail.ac4.yahoo.com ([76.13.13.70]:23915 "HELO
	n7a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750988AbZA3BMJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:12:09 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 742948.21989.bm@omp116.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=rrloSVtffhry2jifaHqHZro3atxF8BBKyKBJpl7oRg3nZn1xIA1vatS6oOg4qCUbcfHQ7i1+Pt7Cn8a0eBckampMVEcFOJCZ8qxo8DSsvWhlNlgCdPwEXvw20Z+4wcfCpUWVhV71P9F+/KmHYAPuPiuOWgpC6375ANICNCvGrXg=;
X-YMail-OSG: 2uPR1P0VM1nEL7qOXKG2Zxc0JNBWVcwIleS4tmNOkM9V_ZVAxmkugW98zwt16IaVUfGfCgYDhaQw.pbMpbxamdZgfngYz3FXy_BcUZ4_jQ2JV0zQsRwVb3B0TcEStjNOqH9KzPLzhKZZbxbndJD1IEhtK1JdUJSwwlPpHfsW7KpdKIZoLclQL.YvTvOE
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 29 Jan 2009 17:12:06 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Wes Felter <wesley@felter.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <498215C9.6090208@felter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <497399.1935.qm@web59909.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It works on my machine. Thanks for the help!

Xiaoning


--- On Thu, 1/29/09, Wes Felter <wesley@felter.org> wrote:

> From: Wes Felter <wesley@felter.org>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: dingxn@ymail.com
> Cc: linux-kernel@vger.kernel.org
> Date: Thursday, January 29, 2009, 8:47 PM
> This will give you an effective speed of 250 MHz:
> 
> for cpu in 0 1 2 3; do
> 	cpufreq-set -c $cpu -g userspace
> 	cpufreq-set -c $cpu -u 2.0GHz
> 	wrmsr -p $cpu 0x19A 0x12
> done
> 
> 0x19A is the IA32_CLOCK_MODULATION MSR and 0x12 is
> calculated from the Intel 64 and IA-32 Architectures
> Software Developer’s Manual section 13.5.3. Legal MSR
> values are 0x12 (12.5% duty cycle) - 0x1E (87.5%) or 0x00
> for 100%. I tested it on a quad-core Xeon and it works.
> 
> This is somewhat reckless, so use it with caution.
> 
> Wes Felter - wesley@felter.org


      

