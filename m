Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZALCpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZALCpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZALCo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 21:44:57 -0500
Received: from web34401.mail.mud.yahoo.com ([66.163.178.150]:48546 "HELO
	web34401.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751645AbZALCo4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:44:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=m0OSkdQBX+p77U31TQKqvjwKeQxJ8JgNppqHKfVwFItluZy3rjaqOJOOB448KSdfi+IjO1W3c/vwQN5JiBRxT1Ht7m185a5qV6j/q4d3QEOG00uzNFBH8sGrUJUaYHHzfTzeV6kMHqF6UD72zb3R45KTh5GgMAVwoNSDeJ8PuLY=;
X-YMail-OSG: sZGVWMwVM1lFhLzpcxlIvJv1xZ5b68bnHnkW3WIWpSTTxWdIYXiG4V7ib6X7HcsSGIL5sq3Ria9RnmORDYhYmthehdxlqcQVOM7hbHKBDlwX4MqPQTo61yu2Es2nGVHV655v7PV6v7b91.rMIBueYYHOh5SxzOziC7kL0LfStf.dsl2LNbGWw9kdPbXDLaq4A41jaJCCVxdz_qpWoNp.xaEijMLm9w--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sun, 11 Jan 2009 18:44:55 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: How to access a regular file from within a module ?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090111113053.42dc34ad@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <207506.58372.qm@web34401.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> You don't generally get to do this. What are you
> actually trying to achieve ?

Thanks for asking, there are two scenarios, the first one it would be to save an ethernet mac address, I got already emails with some work arounds for this. The other scenario is a little bit more complicated:

The system I am working now ( Kernel drivers + User applications ) performs cryptographic operations and it has a regulatory constraint: the user application have to undergo (expensive) certification everytime it is changed, but that is only true if the user application have access to the cryptographic keys, imagine a i++ is missing in the code, then we have to undergo the expensive certification for that.
To avoid that I am trying to isolate the keys ( about 30 X 128bit keys, some of the keys chance everytime they are used ) and cryptographic algorithm from the application and putting them into the kernel so the application can not access that. Well you would say, saving the keys into a file is not a good security measure as it is accessible, the trick is that before saving the key into the file the kernel would encrypt the keys with another key ( KEK- Key Encryption Key ) and this KEK is stored into non volatile register inside the processor, so although the file is accessible it is encrypted.
In this scenario the user application would request encryption/decryption services from the kernel, but it would never pass the Key to be used during the operation, it would pass a Key Id, like this: encrypt this data using key number 7 and Key number 7 is stored in a file ( encrypted ) the kernel could read.
OK, some would say, the user application could read the key file and passed the encrypted key into the kernel function, the kernel would decrypt the encrypted key and do the operation, which is fine, but some of those keys change at every operation, so they have to be re-stored into the file at every operation, it would be nice to have it done by the kernel.

Thanks!


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
