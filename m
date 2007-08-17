Return-Path: <linux-kernel-owner+w=401wt.eu-S1764499AbXHQS1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764499AbXHQS1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXHQS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:27:42 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:47462 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754504AbXHQS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:27:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3aFgq+6Ww6UBO+aSwE6m8KCrvjrikqWbadem0vtLNrbT7WNqW0Xb1kIFOTfH3/WdZ+UVYX4y+b3svCiyBhjRU9UZKpJRiAiRSY8oN+jeNhL4l6Rnz7Ub2s6bZHCkSNsCZefvYwAFRB6w9cZPOLpUxAE+4BIB0QVRL13b6YjTOk4=  ;
X-YMail-OSG: RNeMI3QVM1npz_v2TFJTYcQGUOj_3mncepSME7RwEpO8.PAEIfM9jW.gHavdxollC.3VY5E3aA--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 12/12] Blackfin serial driver: use new GPIO API
Date: Fri, 17 Aug 2007 10:29:21 -0700
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <11865441373719-git-send-email-bryan.wu@analog.com> <11865441413182-git-send-email-bryan.wu@analog.com>
In-Reply-To: <11865441413182-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708171029.21715.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007, Bryan Wu wrote:
> -       /* Enable UART0 RX and TX on pin 7 & 8 of PORT E */
> -       bfin_write_PORTE_FER(0x180 | bfin_read_PORTE_FER());
> -       bfin_write_PORTE_MUX(0x3C000 | bfin_read_PORTE_MUX());
> +       peripheral_request(P_UART0_TX, DRIVER_NAME);
> +       peripheral_request(P_UART0_RX, DRIVER_NAME);


This is not a GPIO API, so the patch summary and description
are wrong.  That's pin muxing.  You didn't change any of
the GPIO related calls.


